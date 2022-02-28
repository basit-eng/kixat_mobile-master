import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({Key key}) : super(key: key);

  static const routeName = 'notice-screen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(title: Text("Notice Board")),
      body: Container(
        height: size.height,
        width: size.width,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 08,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: RoutineCard(
                classTopic: 'Fundamentals of Mathematics',
                classType: 'Theory Class',
                subject: 'Mathematics',
                professor: 'Mr. Ram Prasad Yadav',
                time: '8:00 - 9:00 AM',
              ),
            );
          },
        ),
      ),
    );
  }
}
