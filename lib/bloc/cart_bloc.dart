import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schoolapp/bloc/base_bloc.dart';
import 'package:schoolapp/model/FileUploadResponse.dart';
import 'package:schoolapp/model/PostCheckoutAttrResponse.dart';
import 'package:schoolapp/model/ShoppingCartResponse.dart';
import 'package:schoolapp/model/requestbody/FormValue.dart';
import 'package:schoolapp/model/requestbody/FormValuesRequestBody.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/repository/CartRepository.dart';

class CartBloc extends BaseBloc {
  CartRepository _repository;
  StreamController _scGetCart,
      _loaderSink,
      _scLaunchCheckoutScreen,
      _scErrorMsg,
      _scFileUpload;

  StreamSink<ApiResponse<ShoppingCartResponse>> get cartSink => _scGetCart.sink;
  Stream<ApiResponse<ShoppingCartResponse>> get cartStream => _scGetCart.stream;

  StreamSink<ApiResponse<FileUploadData>> get fileUploadSink =>
      _scFileUpload.sink;
  Stream<ApiResponse<FileUploadData>> get fileUploadStream =>
      _scFileUpload.stream;

  StreamSink<bool> get loaderSink => _loaderSink.sink;
  Stream<bool> get loaderStream => _loaderSink.stream;

  StreamSink<bool> get launchCheckoutSink => _scLaunchCheckoutScreen.sink;
  Stream<bool> get launchCheckoutStream => _scLaunchCheckoutScreen.stream;

  StreamSink<String> get errorMsgSink => _scErrorMsg.sink;
  Stream<String> get errorMsgStream => _scErrorMsg.stream;

  String enteredCouponCode, enteredGiftCardCode;

  CartBloc() {
    _repository = CartRepository();
    _scGetCart = StreamController<ApiResponse<ShoppingCartResponse>>();
    _scFileUpload = StreamController<ApiResponse<FileUploadData>>();
    _loaderSink = StreamController<bool>();
    _scErrorMsg = StreamController<String>();
    _scLaunchCheckoutScreen = StreamController<bool>();
    enteredCouponCode = '';
    enteredGiftCardCode = '';
  }

  fetchCartData() async {
    cartSink.add(ApiResponse.loading());

    try {
      ShoppingCartResponse response = await _repository.fetchCartDetails();
      cartSink.add(ApiResponse.completed(response));
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  updateItemQuantity(CartItem product, num quantity) async {
    List<FormValue> formValues = [];
    formValues.add(FormValue(
        key: 'itemquantity${product.id}', value: quantity.toString()));
    FormValuesRequestBody requestBody =
        FormValuesRequestBody(formValues: formValues);

    await _updateCart(requestBody);
  }

  removeItemFromCart(num cartId) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'removefromcart',
        value: cartId.toString(),
      ),
    ]);

    await _updateCart(requestBody);
  }

  _updateCart(FormValuesRequestBody requestBody) async {
    loaderSink.add(true);

    try {
      ShoppingCartResponse response =
          await _repository.updateShoppingCart(requestBody);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      print(e);
    }
  }

  postCheckoutAttributes(List<FormValue> data, bool checkoutClicked) async {
    loaderSink.add(true);

    var reqBody = FormValuesRequestBody(
      formValues: data,
    );

    try {
      PostCheckoutAttrResponse response =
          await _repository.postCheckoutAttribute(reqBody);
      cartSink.add(ApiResponse.completed(ShoppingCartResponse(
        data: CartData(
          cart: response.cart,
          orderTotals: response.orderTotals,
          selectedCheckoutAttributes: response.selectedCheckoutAttributess,
        ),
      )));
      loaderSink.add(false);
      launchCheckoutSink.add(checkoutClicked);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      launchCheckoutSink.add(false);
    }
  }

  applyDiscountCoupon(String couponCode) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'discountcouponcode',
        value: couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response =
          await _repository.applyCoupon(requestBody);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      String couponMessage = '';
      response.data?.cart?.discountBox?.messages?.forEach((element) {
        couponMessage = couponMessage + element + '\n';
      });
      couponMessage = couponMessage.trimRight();

      if (couponMessage.isNotEmpty) errorMsgSink.add(couponMessage);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      debugPrint(e);
    }
  }

  removeDiscountCoupon(AppliedDiscountsWithCode coupon) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'removediscount-${coupon.id}',
        value: coupon.couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response =
          await _repository.removeCoupon(requestBody);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      String couponMessage = '';
      response.data?.cart?.discountBox?.messages?.forEach((element) {
        couponMessage = couponMessage + element + '\n';
      });
      couponMessage = couponMessage.trimRight();

      if (couponMessage.isNotEmpty) errorMsgSink.add(couponMessage);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      debugPrint(e);
    }
  }

  applyGiftCard(String couponCode) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'giftcardcouponcode',
        value: couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response =
          await _repository.applyGiftCard(requestBody);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      if (response.data?.cart?.giftCardBox?.message?.isNotEmpty == true)
        errorMsgSink.add(response.data?.cart?.giftCardBox?.message);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      debugPrint(e);
    }
  }

  void removeGiftCard(GiftCard giftCard) async {
    FormValuesRequestBody requestBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'removegiftcard-${giftCard.id}',
        value: giftCard.couponCode,
      ),
    ]);

    loaderSink.add(true);

    try {
      ShoppingCartResponse response =
          await _repository.removeGiftCard(requestBody);
      cartSink.add(ApiResponse.completed(response));
      loaderSink.add(false);

      if (response.data?.cart?.giftCardBox?.message?.isNotEmpty == true)
        errorMsgSink.add(response.data?.cart?.giftCardBox?.message);
    } catch (e) {
      cartSink.add(ApiResponse.error(e.toString()));
      loaderSink.add(false);
      debugPrint(e);
    }
  }

  void uploadFile(String filePath, num attributeId) async {
    fileUploadSink.add(ApiResponse.loading());

    try {
      FileUploadResponse response =
          await _repository.uploadFile(filePath, attributeId.toString());
      var uploadFileData = response.data;
      uploadFileData.attributedId = attributeId;

      fileUploadSink.add(ApiResponse.completed(uploadFileData));
    } catch (e) {
      fileUploadSink.add(ApiResponse.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _scGetCart?.close();
    _loaderSink?.close();
    _scErrorMsg?.close();
    _scFileUpload?.close();
    _scLaunchCheckoutScreen?.close();
  }
}
