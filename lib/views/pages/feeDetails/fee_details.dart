import 'package:flutter/material.dart';
import 'package:softify/views/customWidget/CustomAppBar.dart';
import 'package:softify/views/customWidget/home/horizontal_categories.dart';
import 'activity_fee.dart';
import 'exam_fee.dart';
import 'fee_details_screen.dart';

class FeeDetails extends StatelessWidget {
  const FeeDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: Text("Fee Details")),
        body: DefaultTabController(
          length: 03,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                indicatorColor: Colors.lime,
                tabs: [
                  Text(
                    'Fee Detail',
                    style: tabTextStyle(),
                  ),
                  Text(
                    'Exam Fee',
                    style: tabTextStyle(),
                  ),
                  Text(
                    'Activity Fee',
                    style: tabTextStyle(),
                  ),
                ],
              ),
              TabBarView(
                children: [
                  FeeDetailsScreen(),
                  ExpansionPanelDemo(),
                  ActivityFee(),
                ],
              ),
            ],
          ),
        ));
  }

  TextStyle tabTextStyle() => TextStyle(fontSize: 15);
}
