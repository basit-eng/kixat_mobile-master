import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF473F97),
        title: Text(
          'Attendance',
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
        child: Column(
          children: [
            Card(
              elevation: 06,
              child: Container(
                height: 400,
                child: TableCalendar(
                  firstDay: DateTime.utc(2001, 01, 01),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: DateTime.now(),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Color(0xFF473F97),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        border: Border.all(
                          width: 0,
                          color: Colors.grey,
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 10, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAttendanceDotsWidget(
                    attendenceStatus: "Absent",
                    dotColor: Colors.red,
                  ),
                  CustomAttendanceDotsWidget(
                    attendenceStatus: "HalfDay",
                    dotColor: Colors.yellow,
                  ),
                  CustomAttendanceDotsWidget(
                    attendenceStatus: "Leave",
                    dotColor: Colors.green,
                  ),
                  CustomAttendanceDotsWidget(
                    attendenceStatus: "HalfDay",
                    dotColor: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAttendanceDotsWidget extends StatelessWidget {
  const CustomAttendanceDotsWidget(
      {Key key, this.dotColor, this.attendenceStatus})
      : super(key: key);

  final Color dotColor;
  final String attendenceStatus;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      horizontalTitleGap: 0,
      leading: Icon(
        Icons.circle,
        color: dotColor,
      ),
      title: Text(
        attendenceStatus,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
