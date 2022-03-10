import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key key}) : super(key: key);
  static const routeName = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Notifications",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Card(
            elevation: 20,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Today",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Divider(
                    indent: 05,
                    endIndent: 05,
                    height: 3,
                    color: Colors.grey[500],
                  ),
                  CustomNotification(),
                ]),
          ),
          Card(
            elevation: 20,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Early",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Divider(
                    indent: 05,
                    endIndent: 05,
                    height: 3,
                    color: Colors.grey[500],
                  ),
                  CustomNotification(),
                ]),
          )
        ],
      ),
    );
  }
}

class CustomNotification extends StatelessWidget {
  CustomNotification({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customnotificationtile(
              desription: "This is Today Notification",
              dateTime: "20/03/2022",
              context: context,
            ),
            customnotificationtile(
              desription: "This is Today Notification",
              dateTime: "20/03/2022",
              context: context,
            ),
            customnotificationtile(
              desription: "This is Today Notification",
              dateTime: "20/03/2022",
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget customnotificationtile(
      {String desription,
      String dateTime,
      IconData leadingicon,
      BuildContext context}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(leadingicon ?? Icons.notifications),
          title: Text(
            desription,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            "$dateTime",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Icon(
            Icons.close,
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
