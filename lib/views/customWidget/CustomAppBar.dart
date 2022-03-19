import 'package:flutter/material.dart';
import 'package:schoolapp/utils/utility.dart';

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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: centerTitle ?? false,
      leading: leading,
      actions: actions ?? List.empty(),
      flexibleSpace: appbarGradient(context),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
