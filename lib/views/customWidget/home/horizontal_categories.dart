import 'package:flutter/material.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/utils/utility.dart';

import 'package:kixat/views/customWidget/cached_image.dart';
import 'package:kixat/views/pages/assignmentCard_screen.dart';
import 'package:kixat/views/pages/attendance.dart';
import 'package:kixat/views/pages/calender_screen.dart';
import 'package:kixat/views/pages/eventscreen.dart';
import 'package:kixat/views/pages/notice_screen.dart';
import 'package:kixat/views/pages/profile_screen.dart';
import 'package:kixat/views/pages/rountineCard_screen.dart';

import '../../pages/resultcard_screen.dart';

class DashBoardMenu extends StatelessWidget {
  DashBoardMenu({Key key, this.categories}) : super(key: key);

  final List<CategoryTreeResponseData> categories;
  final double boxSize = 40;

  List pagesList = <Widget>[
    AssignmentScreen(),
    EventsScreen(),
    CalenderScreen(),
    ProfileScreen(),
    ResultCardScreen(),
    RountineClassScreen(),
    NoticeScreen(),
    AttendanceScreen(),
  ];
  List imagesList = [
    'assets/list.png',
    'assets/list.png',
    'assets/list.png',
    'assets/list.png',
    'assets/order.png',
    'assets/list.png',
    'assets/logo.png',
    'assets/list.png',
  ];
  List DashBoardMenuItemsName = [
    "Assignments",
    "Events",
    "Calender",
    "Profile",
    "ResultCard",
    "TimeTable",
    "Notice Board",
    "Attendence"
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkThemeEnabled(context) ? Colors.black26 : Colors.white,
          borderRadius: BorderRadius.circular(30),
          // border: Border.all(
          //     // color: isDarkThemeEnabled(context) ? Colors.black26 : Colors.white,
          //     ),
          boxShadow: [
            BoxShadow(
              color: isDarkThemeEnabled(context)
                  ? Colors.black26
                  : Colors.grey[300],
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 05.0, //extend the shadow
              offset: Offset(
                08.0, // Move to right 10  horizontally
                08.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 00),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 08.0,
            mainAxisSpacing: 4.0,
          ),
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pagesList[index]),
                );
                // Navigator.of(context).pushNamed(
                //   ProductListScreen.routeName,
                //   arguments: StudentListScreenArguments(
                //     id: categories[index].categoryId,
                //     name: categories[index].name,
                //     type: GetBy.CATEGORY,
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: CpImage(
                          url: categories[index].iconUrl,
                          height: boxSize,
                          width: boxSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 00),
                      child: Text(
                        DashBoardMenuItemsName[index],
                        // overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
