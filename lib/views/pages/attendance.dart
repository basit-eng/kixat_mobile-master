import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key key}) : super(key: key);

  static const routeName = '/attendence-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Attendence",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Calendar(
              startExpanded:
                  true, // set this to false if you need the calendar to be built shrinked (show only active week)
              onDateSelected: (date) {
                print('Selected date: $date');
                // handle date selection
              },
              onNextMonth: (date) {
                print('Next month: $date');
                // handle on next month.
              },
              onPreviousMonth: (date) {
                print('Previous month: $date');
                // handle previous month
              },
              calendarEvents: [
                CalendarEvent.fromDateTime(
                  dateTime: DateTime.now(),
                  color: SchoolToolkitColors.red,
                ),
              ],
              recurringEventsByDay: [
                CalendarEvent.fromDateTime(
                  dateTime: DateTime(2020, 7, 1),
                  color: SchoolToolkitColors.blue,
                ),
                CalendarEvent.fromDateTime(
                  dateTime: DateTime(2020, 7, 2),
                  color: SchoolToolkitColors.red,
                ),
              ],
              recurringEventsByWeekday: [
                CalendarEvent.fromWeekDay(
                  weekDay: DateTime.sunday,
                  color: SchoolToolkitColors.green,
                  holiday: true,
                ),
              ],
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
      title:
          Text(attendenceStatus, style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
