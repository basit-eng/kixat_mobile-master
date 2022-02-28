import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

import '../customWidget/CustomAppBar.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key key}) : super(key: key);

  static const routeName = '/events-screen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Events",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 08,
          itemBuilder: (context, index) {
            return Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              )),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: EventCard(
                event: 'Sports week Class 3 - Class 10',
                time: '1:00 - 3:00 PM',
                secondaryColor: Color(0XFF6AC0D8),
                // primaryColor: Colors.accents[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
