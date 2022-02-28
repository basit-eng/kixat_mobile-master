import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/GetBy.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/customWidget/cached_image.dart';
import 'package:kixat/views/pages/assignmentCard_screen.dart';
import 'package:kixat/views/pages/attendance.dart';
import 'package:kixat/views/pages/calender_screen.dart';
import 'package:kixat/views/pages/eventscreen.dart';
import 'package:kixat/views/pages/notice_screen.dart';
import 'package:kixat/views/pages/product-list/product_list_screen.dart';
import 'package:kixat/views/pages/profile_screen.dart';
import 'package:kixat/views/pages/rountineCard_screen.dart';

import '../../pages/resultcard_screen.dart';

// class HorizontalCategories extends StatelessWidget {
//   final List<CategoryTreeResponseData> categories;
//   final double boxSize = 150;

//   const HorizontalCategories({Key key, this.categories}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List pagesList = <Widget>[
//             AssignmentScreen(),
//       EventsScreen(),
//       CalenderScreen(),
//       ProfileScreen(),
//       //Result Card...
//       ResultCardScreen(),
//       RountineClassScreen(),

//       NoticeScreen(),
//       AttendanceScreen(),
//     ];
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       color:
//           isDarkThemeEnabled(context) ? Color(0xFF2D2C2C) : Color(0xFFECEDF4),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 5),
//           // Padding(
//           //   padding: EdgeInsets.symmetric(horizontal: 5),
//           //   child: Text(
//           //     GlobalService()
//           //         .getString(Const.HOME_OUR_CATEGORIES)
//           //         .toUpperCase(),
//           //     style: Theme.of(context).textTheme.headline6,
//           //   ),
//           // ),
//           Container(
//             height: size.height,
//             width: double.infinity,
//             child: GridView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 250,
//                     mainAxisExtent: 200,
//                     crossAxisSpacing: 08,
//                     mainAxisSpacing: 08),
//                 shrinkWrap: true,
//                 itemCount: categories.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => pagesList[index]),
//                       );
//                       // Navigator.of(context).pushNamed(
//                       //   ProductListScreen.routeName,
//                       //   arguments: StudentListScreenArguments(
//                       //     id: categories[index].categoryId,
//                       //     name: categories[index].name,
//                       //     type: GetBy.CATEGORY,
//                       //   ),
//                       // );
//                     },
//                     child: Card(
//                       // color: Colors.primaries[index],
//                       margin:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 04),
//                       elevation: 3,
//                       // shape: RoundedRectangleBorder(
//                       //   borderRadius: BorderRadius.circular(15),
//                       // ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                             child: CpImage(
//                               url: categories[index].iconUrl,
//                               height: boxSize,
//                               width: boxSize,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               categories[index].name,
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DashBoardMenu extends StatelessWidget {
  DashBoardMenu({Key key, this.categories}) : super(key: key);

  final List<CategoryTreeResponseData> categories;
  final double boxSize = 40;

  List pagesList = <Widget>[
    AssignmentScreen(),
    EventsScreen(),
    CalenderScreen(),
    ProfileScreen(),
    //Result Card...
    ResultCardScreen(),
    RountineClassScreen(),
    NoticeScreen(),
    AttendanceScreen(),
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
      child: Card(
        elevation: 07,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 00),
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 08.0,
                mainAxisSpacing: 4.0,
              ),
              shrinkWrap: true,
              itemCount: DashBoardMenuItemsName.length,
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
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
