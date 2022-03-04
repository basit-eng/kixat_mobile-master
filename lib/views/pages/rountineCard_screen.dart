import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class RountineClassScreen extends StatelessWidget {
  const RountineClassScreen({Key key}) : super(key: key);

  static const routeName = '/routineClass-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: Text(
        "Time Table",
        style: Theme.of(context).appBarTheme.textTheme.headline6,
      )),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 08,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
