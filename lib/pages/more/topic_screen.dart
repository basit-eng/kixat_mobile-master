import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kixat/bloc/topic_bloc.dart';
import 'package:kixat/customWidget/CustomAppBar.dart';
import 'package:kixat/customWidget/error.dart';
import 'package:kixat/customWidget/loading.dart';
import 'package:kixat/model/TopicResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';

class TopicScreen extends StatefulWidget {
  static const routeName = '/topic';
  final TopicScreenArguments screenArgument;

  const TopicScreen({Key key, this.screenArgument}) : super(key: key);

  @override
  _TopicScreenState createState() => _TopicScreenState(this.screenArgument);
}

class _TopicScreenState extends State<TopicScreen> {
  TopicBloc _bloc;
  final TopicScreenArguments screenArgument;

  _TopicScreenState(this.screenArgument);

  @override
  void initState() {
    super.initState();
    _bloc = TopicBloc();

    if(screenArgument.topicName != null) {
      _bloc.fetchTopicBySystemName(screenArgument.topicName);
    } else if(screenArgument.topicId != null) {
      _bloc.fetchTopicById(screenArgument.topicId);
    } else {
      throw Exception('No topic SystemName or Id found');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var appBarTitle = StreamBuilder<String>(
      stream: _bloc.pageTitleStream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Text(snapshot.data);
        return SizedBox.shrink();
      },
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
      ),
      body: StreamBuilder<ApiResponse<TopicResponse>>(
        stream: _bloc.topicStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                String html = snapshot.data?.data?.data?.body ?? '';
                return SingleChildScrollView(child: Html(data: html));
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () {
                    if(screenArgument.topicName != null) {
                      _bloc.fetchTopicBySystemName(screenArgument.topicName);
                    } else if(screenArgument.topicId != null) {
                      _bloc.fetchTopicById(screenArgument.topicId);
                    }
                  },
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class TopicScreenArguments {
  num topicId;
  String topicName;

  TopicScreenArguments({
    this.topicId, this.topicName
  });
}