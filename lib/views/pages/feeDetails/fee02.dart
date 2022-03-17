import 'package:flutter/material.dart';
import 'package:kixat/utils/sign_config.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/customWidget/richtext.dart';

class FeeScreen extends StatelessWidget {
  const FeeScreen({Key key}) : super(key: key);

  static final routeName = "/fee-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fee Detail",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            feeTypeCustomCard(
              context: context,
              feeType: "Class 01 General Admission Fees",
            ),
            feeTypeCustomCard(
              context: context,
              feeType: "Class 01 General February Month Fees",
            ),
            feeTypeCustomCard(
              context: context,
              feeType: "Class 01 General June Month Fees",
            ),
            feeTypeCustomCard(
              context: context,
              feeType: "Class 01 General August Month Fees",
            ),
          ],
        ),
      ),
    );
  }

  Card feeTypeCustomCard({
    BuildContext context,
    String feeType,
  }) {
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(fontWeight: FontWeight.w600);
    double paid_amt = 10.0;

    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: isDarkThemeEnabled(context)
                  ? Colors.black38
                  : Color(0XFFF5F5F5),
              title: Text(
                feeType,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 2.0 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                  onPressed: () => Container(),
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  )),
            ),
            customFeeRow(
              context: context,
              key: "Fee Code :",
              child: Text("Admission Fee", style: style),
              btn: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: paid_amt == 0.0
                        ? MaterialStateProperty.all(Colors.red)
                        : MaterialStateProperty.all(Colors.blue)),
                onPressed: () => Container(),
                child: Text(
                  "Paid",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            customFeeRow(
              paidAmt: paid_amt,
              context: context,
              key: "Due Date  :",
              child: Text(
                "04-01-2021",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: paid_amt == 0.0 && isDarkThemeEnabled(context)
                        ? Colors.white
                        : isDarkThemeEnabled(context) && paid_amt != 0
                            ? Colors.transparent
                            : !isDarkThemeEnabled(context) && paid_amt != 0
                                ? Colors.black
                                : !isDarkThemeEnabled(context) && paid_amt == 0
                                    ? Colors.white
                                    : Colors.transparent,
                    fontWeight: FontWeight.w600),
              ),
            ),
            customFeeRow(
              context: context,
              key: "Amount  :",
              child: HotRichWidget(
                text1: '1000 PKR ',
                text2: "+ 150 PKR",
              ),
            ),
            customFeeRow(
                context: context,
                key: "Fine  :",
                child: Text(
                  "150 PKR",
                  style: style,
                )),
            customFeeRow(
              context: context,
              key: "Discount  :",
              child: Text("0 PKR", style: style),
            ),
            customFeeRow(
              context: context,
              key: "Paid Amount  :",
              child: Text("$paid_amt", style: style),
            ),
            customFeeRow(
              context: context,
              key: "Balance Amount  :",
              child: Text("0 PKR", style: style),
            )
          ],
        ),
      ),
    );
  }

  customFeeRow(
      {BuildContext context,
      String key,
      Widget child,
      ElevatedButton btn,
      double paidAmt}) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 08),
              child: Container(
                width: size.width * 0.3,
                child: Text(
                  key,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 0, right: 08, top: 02),
                color: paidAmt == 0.0 && isDarkThemeEnabled(context)
                    ? Colors.red
                    : isDarkThemeEnabled(context) && paidAmt != 0
                        ? Colors.transparent
                        : !isDarkThemeEnabled(context) && paidAmt != 0
                            ? Colors.transparent
                            : !isDarkThemeEnabled(context) && paidAmt == 0
                                ? Colors.red
                                : Colors.transparent,
                child: child),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Container(height: 24, child: btn),
            ),
          ],
        ));
  }
}
