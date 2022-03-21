import 'package:flutter/material.dart';
import 'package:softify/bloc/checkout_bloc.dart';
import 'package:softify/views/customWidget/CustomButton.dart';
import 'package:softify/model/SaveBillingResponse.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/utility.dart';

class StepShippingMethod extends StatefulWidget {
  final CheckoutBloc bloc;
  final ShippingMethodModel shippingMethodModel;

  StepShippingMethod(this.bloc, {this.shippingMethodModel});

  @override
  _StepShippingMethodState createState() {
    bloc.selectedShippingMethod =
        shippingMethodModel?.shippingMethods?.firstWhere(
      (element) => element.selected == true,
      orElse: () {
        return shippingMethodModel?.shippingMethods?.first;
      },
    );

    return _StepShippingMethodState(bloc,
        shippingMethodModel: shippingMethodModel);
  }
}

class _StepShippingMethodState extends State<StepShippingMethod> {
  final CheckoutBloc bloc;
  final ShippingMethodModel shippingMethodModel;

  _StepShippingMethodState(this.bloc, {this.shippingMethodModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Column(
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: shippingMethodModel.shippingMethods.length,
            itemBuilder: (context, index) {
              var method = shippingMethodModel.shippingMethods[index];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: method == bloc.selectedShippingMethod
                          ? isDarkThemeEnabled(context)
                              ? Colors.grey[700]
                              : Colors.grey[300]
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    selected: method == bloc.selectedShippingMethod,
                    onTap: () {
                      setState(() {
                        bloc.selectedShippingMethod = method;
                      });
                    },
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        method.name ?? '',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Column(
                          children: [
                            Text(
                              method.fee ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              method.description ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label:
                      GlobalService().getString(Const.CONTINUE).toUpperCase(),
                  onClick: () {
                    bloc.saveShippingMethod();
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
