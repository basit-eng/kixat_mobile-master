import 'package:flutter/material.dart';

class ExamSchedule extends StatelessWidget {
  const ExamSchedule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>[
      'English',
      'Science',
      'Computer',
      'Mathimatics',
      'urdu',
      'Islamiat'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Schedule"),
      ),
      body: Center(
        // child: ListView(
        //   children: [
        //     Row(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Icon(
        //             Icons.book,
        //             color: Colors.black,
        //             size: 24.0,
        //           ),
        //         ),
        //         Text('English'),
        //         // SizedBox(
        //         //   width: 10,
        //         // ),
        //         Text("data"),
        //       ],
        //     )
        //   ],
        // ),
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    tileColor: Color.fromARGB(255, 200, 199, 198),
                    leading: Icon(
                      Icons.book,
                      color: Colors.black,
                    ),
                    minLeadingWidth: 10,
                    title: Text(
                      ' ${entries[index]}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Text('Room No'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                    ),
                    minLeadingWidth: 10,
                    title: Text(
                      'Date',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text('20-02-022'),
                    trailing: Icon(Icons.lock_clock_sharp),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
