import 'package:flutter/material.dart';
import 'package:kixat/model/ShoppingCartResponse.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';

class OrderTotalTable extends StatelessWidget {
  final _globalService = GlobalService();
  final OrderTotals orderTotals;

  OrderTotalTable({this.orderTotals});

  @override
  Widget build(BuildContext context) {
    var rowNameStyle = Theme.of(context).textTheme.subtitle2.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    var rowValueStyle = Theme.of(context).textTheme.subtitle2.copyWith(
      color: Theme.of(context).primaryColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    var inBetweenSpace = SizedBox(height: 3,);

    var discountValue = (orderTotals.subTotalDiscount?.isNotEmpty == true)
        ? orderTotals.subTotalDiscount
        : ((orderTotals.orderTotalDiscount?.isNotEmpty == true)
        ? orderTotals.orderTotalDiscount
        : '');

    return Column(
      children: [
        Divider(height: 5, color: Colors.black,),
        inBetweenSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _globalService.getString(Const.SUB_TOTAL),
                style: rowNameStyle,
              ),
            ),
            Flexible(
              child: Text(
                orderTotals.subTotal ?? '',
                style: rowValueStyle,
              ),
            ),
          ],
        ),
        inBetweenSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _globalService.getString(Const.SHIPPING),
                style: rowNameStyle,
              ),
            ),
            Flexible(
              child: Text(
                orderTotals.shipping?.isNotEmpty == true
                    ? orderTotals.shipping
                    :  _globalService.getString(Const.CALCULATED_DURING_CHECKOUT),
                style: rowValueStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        inBetweenSpace,
        if(discountValue?.isNotEmpty == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _globalService.getString(Const.DISCOUNT),
                  style: rowNameStyle,
                ),
              ),
              Flexible(
                child: Text(
                  discountValue,
                  style: rowValueStyle,
                ),
              ),
            ],
          ),
        inBetweenSpace,
        if (orderTotals?.displayTax == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _globalService.getString(Const.TAX),
                  style: rowNameStyle,
                ),
              ),
              Flexible(
                child: Text(
                  orderTotals.tax ?? '',
                  style: rowValueStyle,
                ),
              ),
            ],
          ),
        if (orderTotals?.displayTax == true)
          inBetweenSpace,
        if (orderTotals?.displayTaxRates == true)
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: orderTotals.taxRates.length,
            itemBuilder: (context, index) {
              return Text(
                  "${_globalService.getString(Const.TAX)} ${orderTotals.taxRates[index].rate}%"
                  " -- ${orderTotals.taxRates[index].value}");
            },
          ),
        if (orderTotals?.displayTaxRates == true)
          inBetweenSpace,
        if (orderTotals?.giftCards?.isNotEmpty)
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: orderTotals.giftCards.length,
            itemBuilder: (context, index) {
              final textPart1 = '${_globalService.getString(Const.GIFT_CARD)} (${orderTotals.giftCards[index].couponCode})';
              final textPart2 = orderTotals.giftCards[index].remaining != null
                  ? '\n${_globalService.getStringWithNumberStr(Const.GIFT_CARD_REMAINING, orderTotals.giftCards[index].remaining)}'
                  : '';
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$textPart1$textPart2',
                      style: rowNameStyle,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      orderTotals.giftCards[index].amount,
                      style: rowValueStyle,
                    ),
                  ),
                ],
              );
            },
          ),
        if((orderTotals?.redeemedRewardPoints ?? 0) > 0)
          ...[
            inBetweenSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _globalService.getStringWithNumber(Const.ORDER_REWARD_POINTS, orderTotals?.redeemedRewardPoints ?? 0),
                    style: rowNameStyle,
                  ),
                ),
                Flexible(
                  child: Text(
                    orderTotals?.redeemedRewardPointsAmount ?? '',
                    style: rowValueStyle,
                  ),
                ),
              ],
            ),
          ],
        inBetweenSpace,
        if(orderTotals.paymentMethodAdditionalFee != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _globalService.getString(Const.PAYMENT_FEE),
                  style: rowNameStyle,
                ),
              ),
              Flexible(
                child: Text(orderTotals.paymentMethodAdditionalFee,
                  style: rowValueStyle,
                ),
              ),
            ],
          ),
        inBetweenSpace,
        if(orderTotals.willEarnRewardPoints != null && orderTotals.willEarnRewardPoints != 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _globalService.getString(Const.WILL_EARN),
                  style: rowNameStyle,
                ),
              ),
              Flexible(
                child: Text(
                  _globalService.getStringWithNumber(
                      Const.POINTS, orderTotals.willEarnRewardPoints),
                  style: rowValueStyle,
                ),
              ),
            ],
          ),
        inBetweenSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _globalService.getString(Const.TOTAL),
                style: rowNameStyle,
              ),
            ),
            Flexible(
              child: Text(
                orderTotals.orderTotal?.isNotEmpty == true
                    ? orderTotals.orderTotal
                    :  _globalService.getString(Const.CALCULATED_DURING_CHECKOUT),
                style: rowValueStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        inBetweenSpace,
      ],
    );
  }
}
