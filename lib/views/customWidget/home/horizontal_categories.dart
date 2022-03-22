import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:softify/model/category_tree/CategoryTreeResponse.dart';
import 'package:softify/views/pages/attendance.dart';
import 'package:softify/views/pages/calender_screen.dart';
import 'package:softify/views/pages/documents.dart';
import 'package:softify/views/pages/eventscreen.dart';
import 'package:softify/views/pages/feeDetails/fee02.dart';
import 'package:softify/views/pages/profile_screen.dart';
import 'package:softify/views/pages/resultCard_detail_screen.dart';
import 'package:softify/views/pages/rountineCard_screen.dart';

class DashBoardMenu extends StatelessWidget {
  DashBoardMenu({Key key, this.categories}) : super(key: key);

  final List<CategoryTreeResponseData> categories;
  final double boxSize = 40;

  List pagesList = <Widget>[
    EventsScreen(),
    CalenderScreen(),
    ProfileScreen(),
    FeeScreen(),
    ResultCardDetailScreen(),
    RountineClassScreen(),
    // NoticeScreen(),
    AttendanceScreen(),
    // ReportCardScreen(),
    DocumentsScreen(),
  ];
  List imagesList = <String>[
    'assets/svg/bell.svg',
    'assets/svg/calendar.svg',
    'assets/svg/user.svg',
    'assets/svg/edit-alt.svg',
    'assets/svg/chart-histogram.svg',
    'assets/svg/time-check.svg',
    'assets/svg/list-check.svg',
    'assets/svg/document.svg',
  ];
  List DashBoardMenuItemsName = [
    "Events",
    "Calender",
    "Profile",
    "Fee Details",
    "Result Card",
    "Time Table",
    "Attendence",
    "Documents",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: imagesList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pagesList[index]),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(04)),
                        child: SvgPicture.asset(
                          imagesList[index],
                          color: Colors.blue,
                          height: 25,
                          width: 25,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 00),
                      child: Text(
                        DashBoardMenuItemsName[index],
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
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
