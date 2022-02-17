import 'package:flutter/material.dart';
import 'package:kixat/bloc/checkout_bloc.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:kixat/views/customWidget/error.dart';
import 'package:kixat/views/customWidget/loading.dart';
import 'package:kixat/views/customWidget/loading_dialog.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/views/pages/account/order/order_details_screen.dart';
import 'package:kixat/views/pages/checkout/checkout_webview.dart';
import 'package:kixat/views/pages/checkout/step_checkout_address.dart';
import 'package:kixat/views/pages/checkout/step_confirm_order.dart';
import 'package:kixat/views/pages/checkout/step_payment_methd.dart';
import 'package:kixat/views/pages/checkout/step_shipping_methd.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/CheckoutConstants.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/nop_cart_icons.dart';
import 'package:kixat/utils/styles.dart';
import 'package:kixat/utils/utility.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  GlobalService _globalService = GlobalService();
  CheckoutBloc _bloc;
  Widget currentWidget;

  var isSelected = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    _bloc = CheckoutBloc();
    _bloc.fetchBillingAddress();

    _bloc.getBillingStream.listen((event) {
      switch (event.status) {
        case Status.LOADING:
          currentWidget = Loading(loadingMessage: event.message);
          break;
        case Status.COMPLETED:
          currentWidget = StepCheckoutAddress(UniqueKey(), _bloc,
              billingData: event.data.data, shippingAddress: null);
          break;
        case Status.ERROR:
          currentWidget = Error(
            errorMessage: event.message,
            onRetryPressed: () => _bloc.fetchBillingAddress(),
          );
          break;
      }

      setState(() {});
    });

    _bloc.checkoutPostStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        setState(() {
          switch (event.data?.data?.nextStep ?? 0) {
            case CheckoutConstants.ShippingAddress:
              currentWidget = StepCheckoutAddress(UniqueKey(), _bloc,
                  shippingAddress: event.data?.data?.shippingAddressModel,
                  billingData: null);
              break;
            case CheckoutConstants.ShippingMethod:
              currentWidget = StepShippingMethod(_bloc,
                  shippingMethodModel: event.data?.data?.shippingMethodModel);
              break;
            case CheckoutConstants.PaymentMethod:
              currentWidget = StepPaymentMethod(_bloc,
                  paymentMethodModel: event.data?.data?.paymentMethodModel);
              break;
            case CheckoutConstants.PaymentInfo:
              Navigator.of(context)
                  .pushNamed(
                CheckoutWebView.routeName,
                arguments: CheckoutWebViewScreenData(
                  action: CheckoutConstants.PaymentInfo,
                  screenTitle: _bloc.selectedPaymentMethod?.name,
                ),
              )
                  .then((nextStep) {
                int nextStepInt = int.tryParse(nextStep) ?? 0;

                if (nextStepInt == 0) {
                  // nextStep 0 in payment info means server can't identify the customer from the WebView. This is backend bug.
                  showSnackBar(
                      context,
                      _globalService
                          .getString(Const.COMMON_SOMETHING_WENT_WRONG),
                      true);
                } else {
                  _bloc.gotoNextStep(nextStepInt);
                }
              });
              break;
            case CheckoutConstants.ConfirmOrder:
              currentWidget = StepConfirmOrder(_bloc,
                  confirmModel: event.data?.data?.confirmModel);
              break;
            case CheckoutConstants.RedirectToGateway:
              Navigator.of(context)
                  .pushNamed(
                CheckoutWebView.routeName,
                arguments: CheckoutWebViewScreenData(
                  action: CheckoutConstants.RedirectToGateway,
                  screenTitle: _globalService.getString(Const.ONLINE_PAYMENT),
                ),
              )
                  .then((orderId) {
                if (orderId != null && orderId as int > 0) {
                  _bloc.orderId = orderId;
                  _bloc.gotoNextStep(CheckoutConstants.LeaveCheckout);
                } else {
                  _bloc.gotoNextStep(CheckoutConstants.Completed);
                }
              });
              break;
            case CheckoutConstants.Completed:
              _bloc.orderComplete();
              break;
            case CheckoutConstants.LeaveCheckout:
              _globalService.updateCartCount(0);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return orderCompleteDialog(_bloc.orderId);
                },
              );
              break;
            default:
              showSnackBar(context, 'Next step unknown', true);
              break;
          }
        });
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isSelected[0] = _bloc.currentStep == CheckoutConstants.BillingAddress ||
        _bloc.currentStep == CheckoutConstants.ShippingAddress;
    isSelected[1] = _bloc.currentStep == CheckoutConstants.ShippingMethod;
    isSelected[2] = _bloc.currentStep == CheckoutConstants.PaymentMethod;
    isSelected[3] = _bloc.currentStep == CheckoutConstants.ConfirmOrder;

    var toggleBtnWidth = MediaQuery.of(context).size.width / 4;

    var topButtons = Material(
        elevation: 5,
        child: ToggleButtons(
          children: [
            SizedBox(
              width: toggleBtnWidth,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Icon(NopCart.ic_address),
                  Text(_globalService.getString(Const.ADDRESS_TAB)),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(
              width: toggleBtnWidth,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Icon(NopCart.ic_shipping, size: 22),
                  SizedBox(height: 2),
                  Text(_globalService.getString(Const.SHIPPING_TAB)),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(
              width: toggleBtnWidth,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Icon(NopCart.ic_payment, size: 22),
                  SizedBox(height: 2),
                  Text(_globalService.getString(Const.PAYMENT_TAB)),
                  SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(
              width: toggleBtnWidth,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Icon(NopCart.ic_confirm_order),
                  Text(_globalService.getString(Const.CONFIRM_TAB)),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
          onPressed: (int index) {
            var intendedStep = 0;

            if (index == 0)
              intendedStep = CheckoutConstants.BillingAddress;
            else if (index == 1)
              intendedStep = CheckoutConstants.ShippingMethod;
            else if (index == 2)
              intendedStep = CheckoutConstants.PaymentMethod;
            else if (index == 3) intendedStep = CheckoutConstants.ConfirmOrder;

            if (intendedStep > _bloc.currentStep) {
              showSnackBar(
                  context,
                  _globalService.getString(Const.PLEASE_COMPLETE_PREVIOUS_STEP),
                  true);
            } else if (intendedStep < _bloc.currentStep) {
              debugPrint('Loading step  $intendedStep...');

              // TODO handle manual tab click
            }
          },
          isSelected: isSelected,
          textStyle: TextStyle(fontSize: 15),
          color: Styles.textColor(context),
          selectedColor: Theme.of(context).primaryColor,
          fillColor:
              isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[100],
          renderBorder: false,
        ));

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(_globalService.getString(Const.CHECKOUT)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            topButtons,
            currentWidget,
          ],
        ),
      ),
    );
  }

  Widget orderCompleteDialog(num orderId) {
    return WillPopScope(
      child: AlertDialog(
        title: Text(_globalService.getString(Const.THANK_YOU)),
        content: Text(_globalService.getString(Const.ORDER_PROCESSED) +
            (orderId > 0
                ? '\n${_globalService.getString(Const.ORDER_NUMBER)}: $orderId'
                : '')),
        actions: [
          if (orderId > 0)
            TextButton(
              onPressed: () {
                // clear stack and go to order details page
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OrderDetailsScreen.routeName,
                  (route) => route.isFirst,
                  arguments: OrderDetailsScreenArguments(orderId: orderId),
                );
              },
              child: Text(_globalService.getString(Const.TITLE_ORDER_DETAILS)),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(_globalService.getString(Const.CONTINUE)),
          ),
        ],
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
