import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key key}) : super(key: key);

  static final routeName = "/faq's";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help Desk", style: Theme.of(context).textTheme.headline6),
      ),
      body: Container(
        child: Center(
          child: Text("FAq's",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1),
        ),
      ),
    );
  }
}
