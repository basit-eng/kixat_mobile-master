import 'package:flutter/material.dart';
import 'package:softify/views/customWidget/CustomAppBar.dart';

class ResultCardScreen extends StatelessWidget {
  const ResultCardScreen({Key key}) : super(key: key);

  static const routeName = '/resultcardscreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            title: Text(
          "Result Card",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        )),
        body: Container(
          child: Center(
            child: Text(
              "Result Card Page In progress",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ),
    );
  }
}
