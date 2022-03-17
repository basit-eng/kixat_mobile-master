import 'package:flutter/material.dart';
import 'package:kixat/model/AppLandingResponse.dart';
import 'package:kixat/utils/nop_cart_icons.dart';
import 'package:kixat/utils/sign_config.dart';
import 'package:kixat/views/pages/account/account_screen.dart';
import 'package:kixat/views/pages/account/change_password_screen.dart';
import 'package:kixat/views/pages/account/faq.dart';
import 'package:kixat/views/pages/account/find_us.dart';
import 'package:kixat/views/pages/account/login_screen.dart';
import 'package:kixat/views/pages/assignmentCard_screen.dart';
import 'package:kixat/views/pages/attendance.dart';
import 'package:kixat/views/pages/calender_screen.dart';
import 'package:kixat/views/pages/examSchedule/exam_schedule.dart';
import 'package:kixat/views/pages/home/home_screen.dart';
import 'package:kixat/views/pages/more/contact_us_screen.dart';
import 'package:kixat/views/pages/more/settings_screen.dart';
import 'package:kixat/views/pages/courses.dart';
import 'package:kixat/views/pages/notice_screen.dart';
import 'package:kixat/views/pages/profile_screen.dart';
import 'package:kixat/views/pages/report_card.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  static const routeNamedashboard = '/Dashboard';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    var divider = Divider(
      thickness: 1.5,
      height: 2,
      indent: 10,
      endIndent: 10,
    );
    return SafeArea(
      child: Drawer(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2018/01/15/07/52/woman-3083390_1280.jpg'),
                      ),
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
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 2.4 * SizeConfig.textMultiplier),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "03109987653",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: Colors.white,
                                    letterSpacing: 1.3,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 2.2 * SizeConfig.textMultiplier),
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
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Manage Account",
              icon: Icons.manage_accounts_rounded,
              onTap: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Change Language",
              icon: Icons.language_rounded,
              onTap: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "FAQs",
              icon: Icons.question_answer_rounded,
              onTap: () {
                Navigator.pushNamed(context, FAQScreen.routeName);
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Find Us",
              icon: Icons.find_in_page_rounded,
              onTap: () {
                Navigator.pushNamed(context, FindUsScreen.routeName);
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Contact us",
              icon: Icons.contact_phone_rounded,
              onTap: () {
                Navigator.pushNamed(context, ContactUsScreen.routeName);
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Log Out",
              icon: Icons.login_outlined,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile customListTile(
      {BuildContext context, String title, IconData icon, VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 1.9 * SizeConfig.textMultiplier),
      ),
      onTap: () => onTap(),
    );
  }
}
