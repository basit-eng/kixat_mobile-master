import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/richtext.dart';

class FeeCardWidget extends StatelessWidget {
  const FeeCardWidget({
    this.icon,
    this.title,
    this.fee,
    this.attendence,
    Key key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final double fee;
  final double attendence;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          height: size.height * 0.17,
          width: size.width * 0.29,
          // alignment: Alignment.topCenter,
          padding: EdgeInsets.all(08),
          // decoration: BoxDecoration(
          //     color: Colors.red[250],
          //     borderRadius: BorderRadius.circular(30),
          //     boxShadow: [
          //       BoxShadow(
          //           offset: Offset(6, 6),
          //           color: Color(0xFFFFFFF2).withOpacity(0.5),
          //           spreadRadius: 9,
          //           blurRadius: 20)
          //     ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              RichWidget(
                text1: 'Fee : ',
                text2: "$fee PKR",
              ),
              // RichWidget(
              //   text1: 'Attendence:',
              //   text2: "$attendence",
              // ),
              Divider(
                indent: 05,
                endIndent: 05,
                thickness: 3,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeeCard extends StatelessWidget {
  const FeeCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FeeCardWidget(
              icon: Icons.file_present_sharp,
              attendence: 26,
              fee: 240,
              title: "Previous Month"),
        ),
        Flexible(
          child: FeeCardWidget(
              icon: Icons.file_present_sharp,
              attendence: 26,
              fee: 240,
              title: "Current Month"),
        ),
        Flexible(
          child: FeeCardWidget(
              icon: Icons.file_present_sharp,
              attendence: 26,
              fee: 240,
              title: "Next Month"),
        ),
      ],
    );
    // Container(
    //   child: ListView.builder(
    //       shrinkWrap: true,
    //       scrollDirection: Axis.horizontal,
    //       itemCount: 03,
    //       itemBuilder: (context, index) {
    //         return FeeCardWidget(
    //           icon: index == 1
    //               ? Icons.file_present_sharp
    //               : index == 2
    //                   ? Icons.work_outlined
    //                   : Icons.feed_outlined,
    //           attendence: index == 3 ? null : 26,
    //           fee: 240,
    //           title: index == 1
    //               ? "Previous Month"
    //               : index == 2
    //                   ? "Current Month"
    //                   : "Next Month",
    //         );
    //       }),
    // );
  }
}