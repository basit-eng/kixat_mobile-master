import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class FeeDetailsScreen extends StatefulWidget {
  const FeeDetailsScreen({Key key}) : super(key: key);

  @override
  State<FeeDetailsScreen> createState() => _FeeDetailsScreenState();
}

class _FeeDetailsScreenState extends State<FeeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
    return Text("data");
    // ListView.separated(
    //   padding: EdgeInsets.all(8),
    //   shrinkWrap: true,
    //   itemCount: carditems.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(12),
    //         // color: CustomColors.cardbordercolor,
    //       ),
    //       child: Card(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //         elevation: 0,
    //         child: ListTile(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(12),
    //           ),
    //           title: Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 18.0),
    //             child: Text(
    //               carditems[index],
    //               style: TextStyle(
    //                 fontWeight: FontSize.semiBold,
    //               ),
    //             ),
    //           ),
    //           subtitle: Padding(
    //             padding: const EdgeInsets.only(bottom: 8.0),
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Text(
    //                   'Rs 5000',
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                     left: 20.0,
    //                   ),
    //                   child: SizedBox(
    //                     height: size.height * 0.030,
    //                     child: ElevatedButton(
    //                       style: ButtonStyle(
    //                           backgroundColor:
    //                               MaterialStateProperty.all<Color>(Colors.blue),
    //                           shape: MaterialStateProperty.all<
    //                                   RoundedRectangleBorder>(
    //                               RoundedRectangleBorder(
    //                                   borderRadius:
    //                                       BorderRadius.circular(04)))),
    //                       onPressed: () {
    //                         // Respond to button press
    //                       },
    //                       child: Text(
    //                         'Paid',
    //                         style: Theme.of(context).textTheme.labelSmall,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           trailing: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Flexible(
    //                 flex: 1,
    //                 child: Text(
    //                   '5 feb',
    //                   style: Theme.of(context).textTheme.labelMedium,
    //                 ),
    //               ),
    //               Flexible(
    //                 child: IconButton(
    //                     icon: const Icon(
    //                       Icons.arrow_downward,
    //                     ),
    //                     color: Colors.white,
    //                     onPressed: () {
    //                       Navigator.of(context).push(MaterialPageRoute(
    //                           builder: (context) => FeeDetailExpand()));
    //                     }),
    //               ),
    //             ],
    //           ),
    //           // Text(
    //           // '$event',
    //           // style: TextStyle(
    //           //   color: primaryColor,
    //           //   fontWeight: FontSize.semiBold,
    //           //   fontSize: FontSize.fontSize16,
    //           // )),
    //         ),
    //       ),
    //     );
    //   },
    //   separatorBuilder: (BuildContext context, int index) => const Divider(
    //     color: Colors.transparent,
    //   ),
    // );
  }
}

class FeeDetailExpand extends StatelessWidget {
  const FeeDetailExpand({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
        'data',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
