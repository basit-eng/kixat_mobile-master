import 'package:flutter/material.dart';
import 'package:kixat/model/AppLandingResponse.dart';
import 'package:kixat/utils/nop_cart_icons.dart';
import 'package:kixat/views/pages/account/account_screen.dart';
import 'package:kixat/views/pages/account/change_password_screen.dart';
import 'package:kixat/views/pages/account/login_screen.dart';
import 'package:kixat/views/pages/assignmentCard_screen.dart';
import 'package:kixat/views/pages/attendance.dart';
import 'package:kixat/views/pages/calender_screen.dart';
import 'package:kixat/views/pages/examSchedule/exam_schedule.dart';
import 'package:kixat/views/pages/home/home_screen.dart';
import 'package:kixat/views/pages/more/contact_us_screen.dart';
import 'package:kixat/views/pages/my_courses.dart';
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Manage Account",
              icon: Icons.manage_accounts_rounded,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Change Language",
              icon: Icons.language_rounded,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "FAQs",
              icon: Icons.question_answer_rounded,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignmentScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Exam",
              icon: Icons.question_answer_rounded,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExamSchedule()));
              },
            ),
            customListTile(
              context: context,
              title: "Courses",
              icon: Icons.book_online_rounded,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyCoursesScreen()));
              },
            ),
            divider,
            divider,
            customListTile(
              context: context,
              title: "report",
              icon: Icons.home_repair_service_outlined,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportCardScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Find Us",
              icon: Icons.find_in_page_rounded,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoticeScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Contact us",
              icon: Icons.contact_phone_rounded,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUsScreen()));
              },
            ),
            divider,
            customListTile(
              context: context,
              title: "Log Out",
              icon: Icons.login_outlined,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
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
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
