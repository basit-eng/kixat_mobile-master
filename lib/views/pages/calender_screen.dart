import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({Key key}) : super(key: key);

  static const routeName = '/calender-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Calender",
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
                  color: SchoolToolkitColors.yellow,
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
