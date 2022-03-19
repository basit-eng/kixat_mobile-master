import 'dart:async';

import 'package:schoolapp/model/category_tree/CategoryTreeResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/repository/category_tree/CategoryTreeRepository.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/Const.dart';

class CategoryTreeBloc {
  CategoryTreeRepository _categoryTreeRepository;
  StreamController _categoryTreeStreamCtrl;

  StreamSink<ApiResponse<CategoryTreeResponse>> get categoryTreeSink =>
      _categoryTreeStreamCtrl.sink;
  Stream<ApiResponse<CategoryTreeResponse>> get categoryTreeStream =>
      _categoryTreeStreamCtrl.stream;

  CategoryTreeBloc() {
    _categoryTreeRepository = CategoryTreeRepository();
    _categoryTreeStreamCtrl =
        StreamController<ApiResponse<CategoryTreeResponse>>();
  }

  fetchCategoryTree() async {
    categoryTreeSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      CategoryTreeResponse movies =
          await _categoryTreeRepository.fetchCategoryTree();
      categoryTreeSink.add(ApiResponse.completed(movies));
    } catch (e) {
      categoryTreeSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _categoryTreeStreamCtrl.close();
  }
}
