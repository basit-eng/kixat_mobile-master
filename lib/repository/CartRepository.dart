
import 'package:kixat/model/FileUploadResponse.dart';
import 'package:kixat/model/PostCheckoutAttrResponse.dart';
import 'package:kixat/model/ShoppingCartResponse.dart';
import 'package:kixat/model/requestbody/FormValuesRequestBody.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class CartRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ShoppingCartResponse> fetchCartDetails() async {
    final response = await _helper.get(Endpoints.getCart);
    return ShoppingCartResponse.fromJson(response);
  }

  Future<ShoppingCartResponse> updateShoppingCart(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.updateCart, reqBody);
    return ShoppingCartResponse.fromJson(response);
  }

  Future<PostCheckoutAttrResponse> postCheckoutAttribute(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.checkoutAttributeChange, reqBody);
    return PostCheckoutAttrResponse.fromJson(response);
  }

  Future<ShoppingCartResponse> applyCoupon(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.applyCoupon, reqBody);
    return ShoppingCartResponse.fromJson(response);
  }

  Future<ShoppingCartResponse> removeCoupon(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.removeCoupon, reqBody);
    return ShoppingCartResponse.fromJson(response);
  }

  Future<ShoppingCartResponse> applyGiftCard(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.applyGiftCard, reqBody);
    return ShoppingCartResponse.fromJson(response);
  }

  Future<ShoppingCartResponse> removeGiftCard(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.removeGiftCard, reqBody);
    return ShoppingCartResponse.fromJson(response);
  }

  Future<FileUploadResponse> uploadFile(String filePath, String attributeId) async {
    final response = await _helper.multipart('${Endpoints.uploadFileCheckoutAttribute}/$attributeId', filePath);
    return FileUploadResponse.fromJson(response);
  }
}