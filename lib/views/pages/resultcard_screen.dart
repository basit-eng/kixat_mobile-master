import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';

class ResultCardScreen extends StatelessWidget {
  const ResultCardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            title: Text(
          "Result Card",
          style: Theme.of(context).textTheme.bodyMedium,
        )),
        body: Container(
          child: Center(
            child: Text(
              "Result Card Page In progress",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
