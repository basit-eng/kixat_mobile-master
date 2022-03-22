import 'package:flutter/material.dart';
import 'package:softify/utils/sign_config.dart';

class ParentsChild extends StatelessWidget {
  ParentsChild({Key key}) : super(key: key);

  final double box = 100;
  List<dynamic> parents_student = [
    "https://picsum.photos/250?image=9",
    "https://picsum.photos/250?image=5",
    "https://picsum.photos/250?image=7",
    "https://picsum.photos/250?image=6"
  ];
  List<dynamic> parents_student_name = [
    "Ali Abbas atish",
    "Akhtar Hussain",
    "Amjad Ali",
    "Nawaz ud Din"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: box + 10,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: parents_student_name.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 12,
            child: Container(
              width: box,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(parents_student[index]),
                  ),
                  // Image(
                  //   height: box,
                  //   width: box,
                  //   image: NetworkImage(parents_student[index]),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 02),
                      child: Text(parents_student_name[index],
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 1.6 * SizeConfig.textMultiplier)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
