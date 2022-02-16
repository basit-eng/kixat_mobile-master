import 'dart:async';

import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/repository/category_tree/CategoryTreeRepository.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';

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
