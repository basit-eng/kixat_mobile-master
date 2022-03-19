import 'package:flutter/material.dart';
import 'package:schoolapp/bloc/order_bloc.dart';
import 'package:schoolapp/views/customWidget/CustomAppBar.dart';
import 'package:schoolapp/views/customWidget/loading.dart';
import 'package:schoolapp/views/customWidget/error.dart';
import 'package:schoolapp/model/OrderHistoryResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/views/pages/account/returnRequest/ReturnRequestScreen.dart';
import 'package:schoolapp/views/pages/account/order/order_details_screen.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/utility.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const routeName = '/order-history';

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  GlobalService _globalService = GlobalService();
  OrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = OrderBloc();
    _bloc.fetchOrderHistory();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          _globalService.getString(Const.ACCOUNT_ORDERS),
        ),
      ),
      body: StreamBuilder<ApiResponse<OrderHistoryResponse>>(
        stream: _bloc.orderHistoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data?.data?.data?.orders ?? []);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchOrderHistory(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(List<Order> orderList) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            return listItem(orderList[index]);
          },
        ),
        if (orderList.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Text(_globalService.getString(Const.COMMON_NO_DATA)),
          ),
      ],
    );
  }

  Widget listItem(Order item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          OrderDetailsScreen.routeName,
          arguments: OrderDetailsScreenArguments(
            orderId: item.id,
          ),
        );
      },
      child: ListTile(
        leading: Icon(Icons.credit_card_outlined),
        title: Text(
            '${_globalService.getString(Const.ORDER_NUMBER)} ${item.customOrderNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${_globalService.getString(Const.ORDER_STATUS)}: ${item.orderStatus}'),
            Text(
                '${_globalService.getString(Const.ORDER_DATE)}: ${getFormattedDate(item.createdOn)}'),
            Text(
                '${_globalService.getString(Const.ORDER_TOTAL)}: ${item.orderTotal}'),
            if (item.isReturnRequestAllowed)
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed(
                    ReturnRequestScreen.routeName,
                    arguments: ReturnRequestScreenArgs(item.id)),
                child: Text(_globalService.getString(Const.ORDER_RETURN_ITEMS)),
              ),
            Divider(),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right_outlined),
      ),
    );
  }
}
