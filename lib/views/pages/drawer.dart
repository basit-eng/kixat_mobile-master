import 'package:flutter/material.dart';
import 'package:kixat/utils/nop_cart_icons.dart';
import 'package:kixat/views/pages/attendance.dart';
import 'package:kixat/views/pages/calender_screen.dart';
import 'package:kixat/views/pages/notice_screen.dart';
import 'package:kixat/views/pages/profile_screen.dart';
import 'package:kixat/views/pages/report_card.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  static const routeName = '/Dashboard';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    var divider = Divider(
      thickness: 1,
      height: 2,
      indent: 25,
      endIndent: 15,
    );
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/user.png"),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Akhtar Abbas ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          "03109987653",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            customListTile(
              context: context,
              title: "My Profile",
              icon: Icons.account_box_rounded,
            ),
            divider,
            customListTile(
                context: context,
                title: "Manage Account",
                icon: Icons.manage_accounts_rounded),
            divider,
            customListTile(
              context: context,
              title: "Change Language",
              icon: Icons.language_rounded,
            ),
            divider,
            customListTile(
              context: context,
              title: "FAQs",
              icon: Icons.question_answer_rounded,
            ),
            divider,
            customListTile(
              context: context,
              title: "report",
              icon: Icons.home_repair_service_outlined,
            ),
            divider,
            customListTile(
              context: context,
              title: "Find Us",
              icon: Icons.find_in_page_rounded,
            ),
            divider,
            customListTile(
              context: context,
              title: "Contact us",
              icon: Icons.contact_phone_rounded,
            ),
            divider,
            customListTile(
                context: context, title: "Log Out", icon: Icons.login_outlined),
          ],
        ),
      ),
    );
  }

  ListTile customListTile({BuildContext context, String title, IconData icon}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NoticeScreen()));
      },
    );
  }
}
