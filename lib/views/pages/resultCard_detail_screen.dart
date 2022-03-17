// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:kixat/views/pages/report_card.dart';

class ResultCardDetailScreen extends StatelessWidget {
  ResultCardDetailScreen({Key key}) : super(key: key);
  static const routeName = '/ResultCardDetailScreen';

  @override
  Widget build(BuildContext context) {
    ReportCardScreen agrs;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Result Card Detail",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: customReportCard(
          context: context,
          title: "Mothly Test Result",
          btnText: "Pass",
          buttonColor: Colors.green,
        ),
      ),
    );
  }
}

customReportCard(
    {String title, Color buttonColor, String btnText, BuildContext context}) {
  double box = 24;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Card(
        margin: EdgeInsets.all(0),
        // color: Colors.grey[200],
        elevation: 4,
        child: ListTile(
          leading: Icon(
            Icons.chrome_reader_mode,
            size: 20,
          ),
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
          trailing: SizedBox(
            height: box,
            child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                ),
                child: Text(
                  btnText,
                  style: Theme.of(context).textTheme.labelMedium.copyWith(
                        fontSize: 14,
                        color: isDarkThemeEnabled(context)
                            ? Colors.black38
                            : Color(
                                0XFFF5F5F5,
                              ),
                      ),
                )),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            customReportMenu(title: "Subjects", context: context),
            customReportMenu(title: "Total Marks ", context: context),
            customReportMenu(title: "Obt. Marks", context: context),
            customReportMenu(title: "Remark", context: context),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 02),
        child: CustomReportResult(
          result: ["Maths", "90", "91%", "A+"],
        ),
      ),
      Divider(
        thickness: 2,
        indent: 10,
        endIndent: 30,
        color: Colors.grey[300],
      ),
    ],
  );
}

customReportMenu({String title, BuildContext context}) {
  return Expanded(
    child: Text(
      title,
      softWrap: true,
      overflow: TextOverflow.visible,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}

class CustomReportResult extends StatelessWidget {
  CustomReportResult({
    Key key,
    this.result,
  }) : super(key: key);

  List result = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
            itemCount: result.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 80),
                child: Text(
                  result[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              );
            }),
      ),
    );
  }
}
