import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:softify/utils/sign_config.dart';
import 'package:softify/views/customWidget/richtext.dart';

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
    var spacer = SizedBox(
      height: 06,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 08, bottom: 12),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: size.height * 0.16,
          width: size.width * 0.33,
          padding: EdgeInsets.all(08),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 08.0),
                child: SvgPicture.asset(
                  icon,
                  color: Colors.blue,
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 02.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 1.6 * SizeConfig.textMultiplier),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 04.0),
                    child: FittedBox(
                      child: RichWidget(
                        text1: 'Fee : ',
                        text2: "$fee PKR",
                      ),
                    ),
                  ),
                  Divider(
                    indent: 05,
                    endIndent: 05,
                    thickness: 3,
                    color: Colors.blue,
                  ),
                ],
              )
              // RichWidget(
              //   text1: 'Attendence:',
              //   text2: "$attendence",
              // ),
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
              icon: 'assets/svg/assept-document.svg',
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
              icon: "assets/svg/add-document.svg",
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
