import 'package:flutter/material.dart';
import 'package:kixat/utils/utility.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Widget title;
  final bool centerTitle;
  final Widget leading;
  final List<Widget> actions;

  const CustomAppBar(
      {Key key,
      @required this.title,
      this.centerTitle,
      this.leading,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle ?? false,
      leading: leading,
      actions: actions ?? List.empty(),
      flexibleSpace: appbarGradient(),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;

}
