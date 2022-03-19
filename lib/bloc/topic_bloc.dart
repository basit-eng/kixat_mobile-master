import 'dart:async';

import 'package:schoolapp/bloc/base_bloc.dart';
import 'package:schoolapp/model/TopicResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/repository/TopicRepository.dart';

class TopicBloc extends BaseBloc {
  TopicRepository _repository;
  StreamController _scTopic, _scPageTitle;

  StreamSink<ApiResponse<TopicResponse>> get topicSink => _scTopic.sink;
  Stream<ApiResponse<TopicResponse>> get topicStream => _scTopic.stream;

  StreamSink<String> get pageTitleSink => _scPageTitle.sink;
  Stream<String> get pageTitleStream => _scPageTitle.stream;

  TopicBloc() {
    _repository = TopicRepository();
    _scTopic = StreamController<ApiResponse<TopicResponse>>();
    _scPageTitle = StreamController<String>();
  }

  @override
  void dispose() {
    _scTopic?.close();
    _scPageTitle?.close();
  }

  fetchTopicById(num topicId) async {
    topicSink.add(ApiResponse.loading());

    try {
      TopicResponse response = await _repository.fetchTopicById(topicId);
      topicSink.add(ApiResponse.completed(response));
    } catch (e) {
      topicSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchTopicBySystemName(String systemName) async {
    topicSink.add(ApiResponse.loading());

    try {
      TopicResponse response =
          await _repository.fetchTopicBySystemName(systemName);
      topicSink.add(ApiResponse.completed(response));
      pageTitleSink.add(response.data?.title ?? '');
    } catch (e) {
      topicSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
}
