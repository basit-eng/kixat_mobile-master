import 'package:flutter/material.dart';
import 'package:schoolapp/model/RewardPointResponse.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/utility.dart';

class ItemRewardPoint extends StatelessWidget {
  final RewardPoint item;
  final GlobalService _globalService = GlobalService();
  final dateTimeFormat = 'MM/dd/yy hh:mm';

  ItemRewardPoint({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontSize: 14.5,
        );

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Table(
          children: [
            TableRow(children: [
              Text(_globalService.getString(Const.REWARD_POINT_DATE),
                  style: textStyle),
              Text(getFormattedDate(item.createdOn, format: dateTimeFormat),
                  style: textStyle),
            ]),
            TableRow(children: [
              Text(_globalService.getString(Const.REWARD_POINT_),
                  style: textStyle),
              Text(item.points?.toString() ?? '', style: textStyle),
            ]),
            TableRow(children: [
              Text(_globalService.getString(Const.REWARD_POINT_BALANCE),
                  style: textStyle),
              Text(item.pointsBalance ?? '', style: textStyle),
            ]),
            TableRow(children: [
              Text(_globalService.getString(Const.REWARD_POINT_MSG),
                  style: textStyle),
              Text(item.message, style: textStyle),
            ]),
            TableRow(children: [
              Text(_globalService.getString(Const.REWARD_POINT_END_DATE),
                  style: textStyle),
              Text(getFormattedDate(item.endDate, format: dateTimeFormat),
                  style: textStyle),
            ]),
          ],
        ),
      ),
    );
  }
}
