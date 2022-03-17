import 'package:flutter/material.dart';

class FindUsScreen extends StatelessWidget {
  const FindUsScreen({Key key}) : super(key: key);

  static final routeName = "/About-us";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About us", style: Theme.of(context).textTheme.headline6),
      ),
      body: Container(
        child: Center(
          child: Text("You can find Us on Following Links and Addresses",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1),
        ),
      ),
    );
  }
}
