import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF473F97),
        title: const Text(
          'Notice Board',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
          height: size.height,
          width: size.width,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 300,
              crossAxisSpacing: 05,
              mainAxisSpacing: 05,
            ),
            shrinkWrap: true,
            itemCount: 08,
            itemBuilder: (context, index) {
              return CustomNotice(
                cardColor: Colors.primaries[index],
                title: "Basit Ali",
                description:
                    "I am glad to share that we have configured a server at the campus with more than 55000 eBooks. Here I am sharing the attached documents about the access options through the campus network and remotely through VPN.",
              );
            },
          )),
    );
  }
}

class CustomNotice extends StatelessWidget {
  CustomNotice({
    Key key,
    this.description,
    this.title,
    this.cardColor,
  }) : super(key: key);
  final String description;
  Color cardColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('EEE d MMM').format(now);
    return Card(
      color: cardColor,
      margin: EdgeInsets.symmetric(vertical: 08, horizontal: 16),
      elevation: 08,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            indent: 10,
            endIndent: 10,
            color: Colors.grey[300],
          ),
          Flexible(
            flex: 01,
            child: Padding(
              padding: EdgeInsets.only(top: 6.0, left: 12, right: 12),
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                horizontalTitleGap: -12,
                minVerticalPadding: 0,
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
