// import 'package:flutter/material.dart';
// import 'package:schoolapp/model/ShoppingCartResponse.dart';
// import 'package:school_ui_toolkit/school_ui_toolkit.dart';

// import '../../utils/custom_colors.dart';
// import 'fee_details_screen.dart';

// class TestExpandableView extends StatefulWidget {
//   @override
//   _TestExpandableViewState createState() => _TestExpandableViewState();
// }

// class _TestExpandableViewState extends State<TestExpandableView> {
//   int _activeMeterIndex;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     List expandedItems = <String>[
//       "School fee for January",
//       "School fee for Febuary",
//       "School fee for March",
//       "School fee for April",
//       "School fee for May",
//       "School fee for June",
//       "School fee for July",
//       "School fee for August",
//       "School fee for September"
//     ];
//     List carditems = <String>[
//       "School fee for January",
//       "School fee for Febuary",
//       "School fee for March",
//       "School fee for April",
//       "School fee for May",
//       "School fee for June",
//       "School fee for July",
//       "School fee for August",
//       "School fee for September"
//     ];
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         // color: CustomColors.cardbordercolor,
//       ),
//       child: new ListView.builder(
//         itemCount: carditems.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Card(
//             color: CustomColors.cardcolor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 0,
//             margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
//             child: new ExpansionPanelList(
//               elevation: 1,
//               expansionCallback: (int index, bool status) {
//                 setState(() {
//                   carditems[index].expanded = !carditems[index].expanded;
//                 });
//               },
//               children: [
//                 new ExpansionPanel(
//                     backgroundColor: CustomColors.cardcolor,
//                     isExpanded: _activeMeterIndex == index,
//                     headerBuilder: (BuildContext context, bool isExpanded) =>
//                         new Container(
//                           height: 290,
//                           color: Colors.green,
//                         ),
//                     body: Container(child: Text("This is Expanded"))
//                     // GridView.count(

//                     //   primary: false,
//                     //   padding: const EdgeInsets.all(20),
//                     //   crossAxisSpacing: 10,
//                     //   mainAxisSpacing: 10,
//                     //   crossAxisCount: 2,
//                     //   children: <Widget>[
//                     //     Container(
//                     //       padding: const EdgeInsets.all(8),
//                     //       child: const Text("He'd have you all unravel at the"),
//                     //       color: Colors.teal[100],
//                     //     ),
//                     //     Container(
//                     //       padding: const EdgeInsets.all(8),
//                     //       child: const Text('Heed not the rabble'),
//                     //       color: Colors.teal[200],
//                     //     ),
//                     //     Container(
//                     //       padding: const EdgeInsets.all(8),
//                     //       child: const Text('Sound of screams but the'),
//                     //       color: Colors.teal[300],
//                     //     ),
//                     //     Container(
//                     //       padding: const EdgeInsets.all(8),
//                     //       child: const Text('Who scream'),
//                     //       color: Colors.teal[400],
//                     //     ),
//                     //     Container(
//                     //       padding: const EdgeInsets.all(8),
//                     //       child: const Text('Revolution is coming...'),
//                     //       color: Colors.teal[500],
//                     //     ),
//                     //     Container(
//                     //       padding: const EdgeInsets.all(8),
//                     //       child: const Text('Revolution, they...'),
//                     //       color: Colors.teal[600],
//                     //     ),
//                     //   ],
//                     // ),
//                     ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpansionPanelDemo extends StatefulWidget {
  @override
  _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
}

class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
  @override
  Widget build(BuildContext context) {
    List carditems = <String>[
      "School fee for January",
      "School fee for Febuary",
      "School fee for March",
      "School fee for April",
      "School fee for May",
      "School fee for June",
      "School fee for July",
      "School fee for August",
      "School fee for September"
    ];
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: itemData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ExpansionPanelList(
                animationDuration: Duration(milliseconds: 1000),
                elevation: 1,
                children: [
                  ExpansionPanel(
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipOval(
                            child: CircleAvatar(
                              child: Image.asset(
                                itemData[index].img,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            itemData[index].discription,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                letterSpacing: 0.3,
                                height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          itemData[index].headerItem,
                          style: TextStyle(
                            color: itemData[index].colorsItem,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                    isExpanded: itemData[index].expanded,
                  )
                ],
                expansionCallback: (int item, bool status) {
                  setState(() {
                    itemData[index].expanded = !itemData[index].expanded;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
        headerItem: 'School Fee January',
        discription:
            "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
        colorsItem: Colors.green,
        img: 'assets/images/android_img.png'),
    ItemModel(
        headerItem: 'Android',
        discription:
            "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
        colorsItem: Colors.green,
        img: 'assets/images/android_img.png'),
  ];
}

class ItemModel {
  bool expanded;
  String headerItem;
  String discription;
  Color colorsItem;
  String img;

  ItemModel(
      {this.expanded: false,
      this.headerItem,
      this.discription,
      this.colorsItem,
      this.img});
}
