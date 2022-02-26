import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({Key key}) : super(key: key);

  static const routeName = 'calender-screen';

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
            ListView.builder(
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
            )
          ],
        ),
      ),
    );
  }
}
