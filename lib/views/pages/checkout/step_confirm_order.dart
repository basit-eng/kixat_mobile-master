import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:softify/bloc/checkout_bloc.dart';
import 'package:softify/views/customWidget/CustomButton.dart';
import 'package:softify/views/customWidget/order_total_table.dart';
import 'package:softify/model/SaveBillingResponse.dart';
import 'package:softify/views/pages/account/cart/CartListItem.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/utility.dart';

class StepConfirmOrder extends StatefulWidget {
  final CheckoutBloc bloc;
  final ConfirmModel confirmModel;

  StepConfirmOrder(this.bloc, {this.confirmModel});

  @override
  _StepConfirmOrderState createState() =>
      _StepConfirmOrderState(this.bloc, confirmModel: this.confirmModel);
}

class _StepConfirmOrderState extends State<StepConfirmOrder> {
  final CheckoutBloc bloc;
  final ConfirmModel confirmModel;
  GlobalService _globalService = GlobalService();

  _StepConfirmOrderState(this.bloc, {this.confirmModel});

  @override
  Widget build(BuildContext context) {
    var billingAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.location_pin),
        title: Text(_globalService.getString(Const.BILLING_ADDRESS_TAB)),
        subtitle: Text(getFormattedAddress(
            confirmModel.cart.orderReviewData.billingAddress)),
      ),
    );

    var shippingAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.location_pin),
        title: Text(_globalService.getString(Const.SHIPPING_ADDRESS_TAB)),
        subtitle: Text(getFormattedAddress(
            confirmModel.cart.orderReviewData.shippingAddress)),
      ),
    );

    var storeAdrsCard = Card(
      child: ListTile(
        leading: Icon(Icons.pin_drop),
        title: Text(_globalService.getString(Const.PICK_UP_POINT_ADDRESS)),
        subtitle: Text(getFormattedAddress(
            confirmModel.cart.orderReviewData.pickupAddress)),
      ),
    );

    var shippingMethodCard = Card(
      child: ListTile(
        leading: Icon(Icons.local_shipping),
        title: Text(_globalService.getString(Const.SHIPPING_METHOD)),
        subtitle: Text(confirmModel.cart.orderReviewData.shippingMethod ?? ''),
      ),
    );

    var paymetnMethodCard = Card(
      child: ListTile(
        leading: Icon(Icons.payment_outlined),
        title: Text(_globalService.getString(Const.PAYMENT_METHOD)),
        subtitle: Text(confirmModel.cart.orderReviewData.paymentMethod ?? ''),
      ),
    );

    var cartItems = ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: confirmModel.cart.items.length,
      itemBuilder: (context, index) {
        return CartListItem(
          item: confirmModel.cart.items[index],
          onClick: (map) {},
          editable: false,
        );
      },
    );

    var selectedAttributes = Card(
      child: ListTile(
        title: Text(_globalService.getString(Const.SELECTED_ATTRIBUTES)),
        subtitle: Html(
          data: confirmModel.selectedCheckoutAttributes ?? '',
          style: htmlNoPaddingStyle(),
          onLinkTap: (url, context, attributes, element) {},
        ),
      ),
    );

    // Warning Messages
    var warningMsg =
        confirmModel.cart?.minOrderSubtotalWarning?.isNotEmpty == true
            ? '${confirmModel.cart?.minOrderSubtotalWarning}\n'
            : '';

    confirmModel.cart?.warnings?.forEach((element) {
      warningMsg = '$warningMsg$element\n';
    });
    warningMsg.trimRight();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Column(
        children: [
          if (confirmModel.cart.orderReviewData.display) billingAdrsCard,
          if (confirmModel.cart.orderReviewData.display &&
              confirmModel.cart.orderReviewData.isShippable &&
              !confirmModel.cart.orderReviewData.selectedPickupInStore)
            shippingAdrsCard,
          if (confirmModel.cart.orderReviewData.display &&
              confirmModel.cart.orderReviewData.selectedPickupInStore)
            storeAdrsCard,
          if (confirmModel.cart.orderReviewData.display) shippingMethodCard,
          if (confirmModel.cart.orderReviewData.display) paymetnMethodCard,
          if (confirmModel.selectedCheckoutAttributes.isNotEmpty)
            selectedAttributes,
          cartItems,
          if (warningMsg.isNotEmpty)
            Text(
              warningMsg,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          SizedBox(height: 10),
          OrderTotalTable(orderTotals: confirmModel.orderTotals),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: GlobalService()
                      .getString(Const.CONFIRM_BUTTON)
                      .toUpperCase(),
                  onClick: () {
                    bloc.confirmOrder();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
