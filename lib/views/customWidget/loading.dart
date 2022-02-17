import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String loadingMessage;
  const Loading({Key key, this.loadingMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
          ),
          SizedBox(height: 24),
          Platform.isIOS
            ? CupertinoActivityIndicator()
            : CircularProgressIndicator(
                strokeWidth: 3,
              ),
        ],
      ),
    );
  }
}