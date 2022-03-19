import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/nop_cart_icons.dart';
import 'package:schoolapp/utils/AppConstants.dart';
import 'package:schoolapp/views/pages/account/cart/shopping_cart_screen.dart';

class AppBarCart extends StatefulWidget {
  @override
  _AppBarCartState createState() => _AppBarCartState();
}

class _AppBarCartState extends State<AppBarCart> {
  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return StreamBuilder<int>(
      initialData: GlobalService().getCartCount,
      stream: GlobalService().cartCountStream,
      builder: (context, snapshot) {
        return Padding(
          padding: isRtl
              ? EdgeInsets.fromLTRB(20, 0, 20, 0)
              : EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
            },
            child: Container(),
            // Badge(
            //     position: BadgePosition.topEnd(top: 4, end: -15),
            //     badgeContent: Text(
            //       (snapshot?.data ?? 0).toString(),
            //       style: TextStyle(
            //           fontSize: 10,
            //           color: Theme.of(context)
            //               .appBarTheme
            //               .textTheme
            //               .headline6
            //               .color),
            //     ),
            //     // badgeColor: Theme.of(context).primaryColor,
            //     child: Image(
            //       image: AssetImage(AppConstants.cartIcon_black),
            //       width: 0,
            //     ) //Icon(NopCart.ic_cart),
            //     ),
          ),
        );
      },
    );
  }
}
