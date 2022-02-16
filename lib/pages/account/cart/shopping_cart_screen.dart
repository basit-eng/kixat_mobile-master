import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kixat/bloc/cart_bloc.dart';
import 'package:kixat/customWidget/CustomAppBar.dart';
import 'package:kixat/customWidget/CustomButton.dart';
import 'package:kixat/customWidget/error.dart';
import 'package:kixat/customWidget/estimate_shipping.dart';
import 'package:kixat/customWidget/loading.dart';
import 'package:kixat/customWidget/loading_dialog.dart';
import 'package:kixat/customWidget/order_total_table.dart';
import 'package:kixat/model/ShoppingCartResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/pages/account/cart/CartListItem.dart';
import 'package:kixat/pages/account/login_screen.dart';
import 'package:kixat/pages/account/registration_sceen.dart';
import 'package:kixat/pages/checkout/checkout_screen.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/AppConstants.dart';
import 'package:kixat/utils/ButtonShape.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/CustomAttributeManager.dart';
import 'package:kixat/utils/styles.dart';
import 'package:kixat/utils/utility.dart';

class ShoppingCartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  GlobalService _globalService = GlobalService();
  CartBloc _bloc;
  CustomAttributeManager attributeManager;

  @override
  void initState() {
    super.initState();
    _bloc = CartBloc();
    _bloc.fetchCartData();

    _bloc.loaderStream.listen((showLoader) {
      if (showLoader == true) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.launchCheckoutStream.listen((goToCheckout) {
      if (goToCheckout) {
        if (_globalService.isLoggedIn()) {
          Navigator.of(context).pushNamed(CheckoutScreen.routeName);
        } else {
          showCheckoutDialog();
        }
      }
    });

    _bloc.errorMsgStream.listen((message) {
      showSnackBar(context, message, false);
    });

    _bloc.fileUploadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        attributeManager?.addUploadedFileGuid(
            event.data.attributedId, event.data.downloadGuid);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        // updating UI to show selected attribute values
        setState(() {
          if (priceAdjNeeded) {
            var checkoutAttrs =
                attributeManager.getSelectedAttributes('checkout_attribute');
            _bloc.postCheckoutAttributes(checkoutAttrs, false);
          }
        });
      },
      onFileSelected: (file, attributeId) {
        _bloc.uploadFile(file.path, attributeId);
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          _globalService.getString(Const.SHOPPING_CART_TITLE),
        ),
      ),
      body: StreamBuilder<ApiResponse<ShoppingCartResponse>>(
        stream: _bloc.cartStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return getCartDetailsWidget(snapshot.data.data);
                break;
              case Status.ERROR:
                _globalService.updateCartCount(0);
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchCartData(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget getCartDetailsWidget(ShoppingCartResponse data) {
    CartData cartData = data.data;

    print('<> items in cart ${cartData.cart.items.length}');
    // update global cart counter
    var totalItems = 0;
    cartData?.cart?.items?.forEach((element) {
      totalItems += (element?.quantity ?? 0);
    });
    _globalService.updateCartCount(totalItems);

    if (cartData.cart.items.isEmpty)
      return Container(
        child: Center(
          child: Text(_globalService.getString(Const.CART_EMPTY)),
        ),
      );

    var cartItems = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: cartData.cart.items.length,
      itemBuilder: (context, index) {
        return CartListItem(
          item: cartData.cart.items[index],
          onClick: (map) {
            final cartItem = cartData.cart.items[index];
            switch (map['action']) {
              case 'plus':
                _bloc.updateItemQuantity(cartItem, cartItem.quantity + 1);
                break;

              case 'minus':
                _bloc.updateItemQuantity(cartItem, cartItem.quantity - 1);
                break;

              case 'setQuantity':
                _bloc.updateItemQuantity(
                    cartItem, num.tryParse(map['quantity']) ?? 1);
                break;

              case 'remove':
                _bloc.removeItemFromCart(cartData.cart.items[index].id);
                break;
            }
          },
          editable: true,
        );
      },
    );

    var giftCardBox = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 40,
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    onChanged: (value) {
                      _bloc.enteredGiftCardCode = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            24), // border color Color(0xFFD4D3DA)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText: _globalService.getString(Const.ENTER_GIFT_CARD),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 30,
                child: ElevatedButton(
                  onPressed: () {
                    removeFocusFromInputField(context);

                    if (_bloc.enteredGiftCardCode.isNotEmpty)
                      _bloc.applyGiftCard(_bloc.enteredGiftCardCode);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Styles.secondaryButtonColor),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ))),
                  child: Text(
                      _globalService
                          .getString(Const.ADD_GIFT_CARD)
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          if (data.data?.orderTotals?.giftCards?.isNotEmpty == true)
            SizedBox(height: 10),
          if (data.data?.orderTotals?.giftCards?.isNotEmpty == true)
            SizedBox(
              height: 30,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.data?.orderTotals?.giftCards?.length,
                itemBuilder: (context, index) {
                  var item = data.data?.orderTotals?.giftCards[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                      label: Text(_globalService.getStringWithNumber(
                          Const.ENTERED_COUPON_CODE,
                          int.tryParse(item.couponCode))),
                      deleteIcon: Icon(Icons.cancel_rounded),
                      deleteIconColor: Colors.red,
                      onDeleted: () {
                        _bloc.removeGiftCard(item);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    var couponCodeBox = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 40,
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    onChanged: (value) => _bloc.enteredCouponCode = value,
                    textInputAction: TextInputAction.next,
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            24), // border color Color(0xFFD4D3DA)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText:
                          _globalService.getString(Const.ENTER_YOUR_COUPON),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 30,
                child: ElevatedButton(
                  onPressed: () {
                    removeFocusFromInputField(context);

                    if (_bloc.enteredCouponCode.isNotEmpty)
                      _bloc.applyDiscountCoupon(_bloc.enteredCouponCode);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Styles.secondaryButtonColor),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ))),
                  child: Text(
                      _globalService
                          .getString(Const.APPLY_COUPON)
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          if (data.data?.cart?.discountBox?.appliedDiscountsWithCodes
                  ?.isNotEmpty ==
              true)
            SizedBox(height: 10),
          if (data.data?.cart?.discountBox?.appliedDiscountsWithCodes
                  ?.isNotEmpty ==
              true)
            SizedBox(
              height: 30,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data
                    .data?.cart?.discountBox?.appliedDiscountsWithCodes?.length,
                itemBuilder: (context, index) {
                  var item = data.data?.cart?.discountBox
                      ?.appliedDiscountsWithCodes[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                      label: Text(_globalService.getStringWithNumber(
                          Const.ENTERED_COUPON_CODE,
                          int.tryParse(item.couponCode))),
                      deleteIcon: Icon(Icons.cancel_rounded),
                      deleteIconColor: Colors.red,
                      onDeleted: () {
                        _bloc.removeDiscountCoupon(item);
                      },
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 5, 7, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(_globalService.getString(Const.PRODUCTS),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(
                          _globalService.getStringWithNumber(
                              Const.ITEMS, cartData.cart.items.length),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                cartItems,
                attributeManager.populateCustomAttributes(
                    data.data.cart.checkoutAttributes),
                if (cartData.cart.discountBox.display) couponCodeBox,
                if (cartData.cart.giftCardBox.display) giftCardBox,
                if (cartData.estimateShipping?.enabled == true)
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EstimateShippingDialog(
                            cartData.estimateShipping,
                            false,
                          );
                        },
                      );
                    },
                    child: Text(_globalService
                        .getString(Const.CART_ESTIMATE_SHIPPING_BTN)
                        .toUpperCase()),
                  ),
                OrderTotalTable(orderTotals: data.data.orderTotals),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomButton(
            label: _globalService.getString(Const.CHECKOUT).toUpperCase(),
            shape: ButtonShape.RoundedTop,
            onClick: () {
              if (_globalService.isLoggedIn() ||
                  _globalService
                          .getAppLandingData()
                          ?.anonymousCheckoutAllowed ==
                      true) {
                // user allowed to go to checkout
                String errMsg = attributeManager
                    .checkRequiredAttributes(data.data.cart.checkoutAttributes);
                if (errMsg.isNotEmpty) {
                  showSnackBar(context, errMsg, true);
                } else {
                  // post checkout attributes before going to Checkout screen
                  var checkoutAttrs = attributeManager
                      .getSelectedAttributes('checkout_attribute');
                  _bloc.postCheckoutAttributes(checkoutAttrs, true);
                }
              } else {
                // go to login
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              }
            },
          ),
        ),
      ],
    );
  }

  showCheckoutDialog() {
    var text =
        _globalService.getString(Const.CREATE_ACCOUNT_LONG_TEXT).split(";");
    print(text);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Row(
            children: [
              Text(
                _globalService.getString(Const.REGISTER_AND_SAVE_TIME),
                textAlign: TextAlign.left,
              ), // Text(_globalService.getString(Const.CHECKOUT_AS_GUEST_TITLE)),
            ],
          )),
          content: Wrap(
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Row(children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 45),
                      child: Image(
                          image: AssetImage(AppConstants.shop_order),
                          width: 40,
                          height: 40),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 175,
                      child: Transform.scale(
                          scale: 1,
                          child: Text(
                            text[0],
                            style: TextStyle(fontSize: 14),
                          ) //("Check Order status and track change or return items")
                          ),
                    )
                  ]),
                  SizedBox(height: 20),
                  Row(children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 45),
                      child: Image(
                          image: AssetImage(AppConstants.shopping_bag),
                          width: 40,
                          height: 40),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 175,
                      child: Transform.scale(
                          scale: 1,
                          child: Text(text[1],
                              style: TextStyle(
                                  fontSize:
                                      14)) //("Shop past purchases and everyday essentials")
                          ),
                    )
                  ]),
                  SizedBox(height: 20),
                  Row(children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 45),
                      child: Image(
                          image: AssetImage(AppConstants.shopping_list),
                          width: 40,
                          height: 40),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 175,
                      child: Transform.scale(
                          scale: 1,
                          child: Text(text[2],
                              style: TextStyle(
                                  fontSize:
                                      14)) //("Create list with items you want, now or later")
                          ),
                    )
                  ]),
                  //Text(
                  //_globalService.getString(Const.CREATE_ACCOUNT_LONG_TEXT),
                  //textAlign: TextAlign.justify,
                  //style: Theme.of(context).textTheme.subtitle2.copyWith(
                  //fontSize: 16,
                  //),
                  //),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity, // match_parent
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text(
                        _globalService.getString(Const.LOGIN_LOGIN_BTN),
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity, // match_parent
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      child: Text(
                          _globalService.getString(Const.REGISTER_BUTTON),
                          style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            RegistrationScreen.routeName,
                            arguments: RegistrationScreenArguments(
                                getCustomerInfo: false));
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity, // match_parent
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      child: Text(
                          _globalService.getString(Const.CHECKOUT_AS_GUEST),
                          style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(CheckoutScreen.routeName);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
