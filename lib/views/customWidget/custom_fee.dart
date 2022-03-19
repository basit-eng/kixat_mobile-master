import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolapp/utils/sign_config.dart';
import 'package:schoolapp/views/customWidget/richtext.dart';

class FeeCardWidget extends StatelessWidget {
  const FeeCardWidget({
    this.icon,
    this.title,
    this.fee,
    this.attendence,
    Key key,
  }) : super(key: key);

  final String icon;
  final String title;
  final double fee;
  final double attendence;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 08, bottom: 12),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: size.height * 0.16,
          width: size.width * 0.33,
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
                child: SvgPicture.asset(
                  icon,
                  color: Colors.blue,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 1.6 * SizeConfig.textMultiplier),
                  ),
                ),
              ),
              FittedBox(
                child: RichWidget(
                  text1: 'Fee : ',
                  text2: "$fee PKR",
                ),
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
              icon: "assets/svg/form.svg",
              attendence: 26,
              fee: 2400,
              title: "Previous Month"),
        ),
        Flexible(
          child: FeeCardWidget(
              icon: "assets/svg/edit.svg",
              attendence: 20,
              fee: 2600,
              title: "Current Month"),
        ),
        Flexible(
          child: FeeCardWidget(
              icon: "assets/svg/pencil.svg",
              attendence: 0,
              fee: 3000,
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
