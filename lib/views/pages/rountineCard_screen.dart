import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RountineClassScreen extends StatelessWidget {
  const RountineClassScreen({Key key}) : super(key: key);

  static const routeName = 'routineClass-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF473F97),
        title: Text(
          'Time Table',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 08,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: EventCard(
                event: 'Sports week Class 3 - Class 10',
                time: '1:00 - 3:00 PM',
                secondaryColor: Colors.grey[300],
                primaryColor: SchoolToolkitColors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
