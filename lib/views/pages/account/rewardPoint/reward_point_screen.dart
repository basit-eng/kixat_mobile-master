import 'package:flutter/material.dart';
import 'package:schoolapp/bloc/reward_point_bloc.dart';
import 'package:schoolapp/views/customWidget/CustomAppBar.dart';
import 'package:schoolapp/views/customWidget/error.dart';
import 'package:schoolapp/views/customWidget/loading.dart';
import 'package:schoolapp/views/customWidget/loading_dialog.dart';
import 'package:schoolapp/model/RewardPointResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/views/pages/account/rewardPoint/item_reward_point.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/utility.dart';

class RewardPointScreen extends StatefulWidget {
  static const routeName = '/rewardPoint';

  const RewardPointScreen({Key key}) : super(key: key);

  @override
  _RewardPointScreenState createState() => _RewardPointScreenState();
}

class _RewardPointScreenState extends State<RewardPointScreen> {
  RewardPointBloc _bloc;
  GlobalService _globalService = GlobalService();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = RewardPointBloc();

    _bloc.fetchRewardPointDetails();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        debugPrint('calling next page');
        _bloc.fetchRewardPointDetails();
      }
    });

    _bloc.loaderStream.listen((event) {
      if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
      } else {
        DialogBuilder(context).hideLoader();
        if (event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
    _scrollController.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(_globalService.getString(Const.ACCOUNT_REWARD_POINT)),
      ),
      body: StreamBuilder<ApiResponse<RewardPointData>>(
        stream: _bloc.rewardPointStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return snapshot.hasData
                    ? rootWidget(snapshot.data.data)
                    : SizedBox.shrink();
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () {},
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(RewardPointData rewardPoint) {
    var text1 = _globalService
        .getString(Const.REWARD_POINT_BALANCE_CURRENT)
        .replaceAll("{0}", rewardPoint.rewardPointsBalance.toString())
        .replaceAll("{1}", rewardPoint.rewardPointsAmount.toString());

    var text2 = _globalService
        .getString(Const.REWARD_POINT_BALANCE_MIN)
        .replaceAll("{0}", rewardPoint.minimumRewardPointsBalance.toString())
        .replaceAll("{1}", rewardPoint.minimumRewardPointsAmount.toString());

    var displayMsg = (rewardPoint.minimumRewardPointsBalance ?? 0.0) <= 0
        ? text1
        : "$text1\n$text2";

    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                displayMsg,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 16,
                    ),
              ),
            ),
          ),
          if (rewardPoint?.rewardPoints?.isEmpty == true)
            Center(
              child: Text(_globalService.getString(Const.REWARD_NO_HISTORY)),
            ),
          if (rewardPoint?.rewardPoints?.isEmpty == false)
            Expanded(
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: rewardPoint.rewardPoints.length,
                itemBuilder: (context, index) {
                  return ItemRewardPoint(item: rewardPoint.rewardPoints[index]);
                },
              ),
            )
        ],
      ),
    );
  }
}
