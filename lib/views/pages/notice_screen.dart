import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

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
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 08,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: NoticeCard(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                title: 'School Reopens',
                subTitile:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                onTap: () {
                  // Handle readmore
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
