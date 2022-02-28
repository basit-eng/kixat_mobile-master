import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customWidget/CustomAppBar.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({Key key}) : super(key: key);

  static const routeName = 'assignment-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text("Assignment")),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Card(
              elevation: 03,
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: AssignmentCard(
                // optional, if deadline is not passed, deadline card will not be shown
                deadline: DateTime.now(),
                question:
                    'Chapter 3 - Q.no 1 - Q.no 10 (Please submit in word format with names attached)',
                subject: 'Mathematics',
                teacher: 'Dr. Stone',
                deadlineBackgroundColor: SchoolToolkitColors.red,
                onUploadHandler: () {
                  print('Handle upload');
                  // optional, if null is passsed upload button will be hidden
                },
                // optional
                fileList: [
                  FileWrapper(
                    fileName: 'assignment-information.pdf',
                    fileSize: '11.5 KB',
                    onTap: () {
                      print('Handle on tap');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
