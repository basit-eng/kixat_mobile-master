import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:kixat/views/pages/report_card.dart';

class ResultCardDetailScreen extends StatelessWidget {
  const ResultCardDetailScreen({Key key}) : super(key: key);
  static const routeName = '/ResultCardDetailScreen';

  @override
  Widget build(BuildContext context) {
    ReportCardScreen agrs;

    return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            "Report Card Detail",
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            customReportCard(
                result: customReportResult(result: ["120", "90", "91%", "A+"]),
                title: "Mothly Test Result",
                btnText: "Pass",
                buttonColor: Colors.green),
          ],
        ));
  }
}

customReportCard(
    {String title,
    Color buttonColor,
    customReportResult result,
    String btnText}) {
  return Column(
    children: [
      Card(
        margin: EdgeInsets.all(0),
        color: Colors.grey[200],
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            leading: Icon(
              Icons.chrome_reader_mode,
              size: 30,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                ),
                child: Text(btnText)),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 00,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            customReportMenu(title: "Subjects"),
            customReportMenu(title: "Total Marks "),
            customReportMenu(title: "Obtained Marks"),
            customReportMenu(title: "Remark"),
          ],
        ),
      ),
      Divider(
        thickness: 2,
        indent: 10,
        endIndent: 30,
        color: Colors.grey[300],
      ),
      // Padding(
      //   padding: const EdgeInsets.only(
      //     top: 08,
      //     right: 08,
      //     left: 35,
      //   ),
      //   child: result,
      // ),
    ],
  );
}

customReportMenu({
  String title,
}) {
  return Flexible(
    flex: 4,
    child: Padding(
      padding: EdgeInsets.only(left: 12.0, right: 12),
      child: Text(
        title,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class customReportResult extends StatelessWidget {
  customReportResult({
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
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              );
            }),
      ),
    );
  }
}
