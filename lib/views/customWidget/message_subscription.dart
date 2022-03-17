import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_fake.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/utils/sign_config.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/pages/home/home_screen.dart';

class MessageSubsciptionCard extends StatefulWidget {
  MessageSubsciptionCard({
    Key key,
    this.categories,
  }) : super(key: key);

  final List<CategoryTreeResponseData> categories;

  @override
  State<MessageSubsciptionCard> createState() => _MessageSubsciptionCardState();
}

class _MessageSubsciptionCardState extends State<MessageSubsciptionCard> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // decoration: BoxDecoration(
        //   color: isDarkThemeEnabled(context) ? Colors.black26 : Colors.white,
        //   borderRadius: BorderRadius.circular(30),
        //   // border: Border.all(color: Colors.grey[100]),
        //   boxShadow: [
        //     BoxShadow(
        //       color: isDarkThemeEnabled(context)
        //           ? Colors.black26
        //           : Colors.grey[400],
        //       blurRadius: 10.0, // soften the shadow
        //       spreadRadius: 05.0, //extend the shadow
        //       offset: Offset(
        //         08.0, // Move to right 10  horizontally
        //         08.0, // Move to bottom 10 Vertically
        //       ),
        //     )
        //   ],
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Text(
                "Message Subscription",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 2.0 * SizeConfig.textMultiplier),
              ),
            ),
            Divider(
              indent: 05,
              endIndent: 05,
              thickness: 1,
              color: Colors.grey[300],
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 04,
                itemBuilder: (context, index) {
                  return SwitchButton(
                    title: "Attendence",
                    subtitle: "Daily Attendence | 200 PKR",
                    isSwitched: true,
                    onChange: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  );
                }),
            // messageSubscriptionTile(
            //     title: "Attendence", subtitle: "Daily Attendence | 200 PKR"),
            // messageSubscriptionTile(
            //     title: "Issued Fee",
            //     subtitle: "Message on Fee Issue | 200 PKR"),
            // messageSubscriptionTile(
            //     title: "Fee Received",
            //     subtitle: "Message on Fee Received | 200 PKR"),
            // messageSubscriptionTile(
            //     title: "Result", subtitle: "Message on Fee Exam | 200 PKR"),
          ],
        ),
      ),
    );
  }
}
