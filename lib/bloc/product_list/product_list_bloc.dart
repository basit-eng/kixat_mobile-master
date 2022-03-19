import 'dart:async';

import 'package:schoolapp/model/product_list/ProductListResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/repository/product_list/ProductListRepository.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/Const.dart';

class ProductListBloc {
  ProductListRepository _prodListRepository;
  StreamController _prodListStreamCtrl;

  StreamSink<ApiResponse<ProductListResponse>> get prodListSink =>
      _prodListStreamCtrl.sink;
  Stream<ApiResponse<ProductListResponse>> get prodListStream =>
      _prodListStreamCtrl.stream;

  ProductListBloc() {
    _prodListRepository = ProductListRepository();
    _prodListStreamCtrl =
        StreamController<ApiResponse<ProductListResponse>>.broadcast();
  }

  String type;
  int categoryId;
  int pageNumber;
  String orderBy;
  String price;
  String specs;
  String ms;

  fetchProductList() async {
    prodListSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      Map<String, String> queryParams = {
        'PageNumber': pageNumber.toString(),
        'PageSize': '9',
        'orderby': orderBy,
        'price': price,
        'specs': specs,
        'ms': ms,
      };

      ProductListResponse response = await _prodListRepository.fetchProductList(
          type, categoryId, queryParams);
      prodListSink.add(ApiResponse.completed(response));
    } catch (e) {
      prodListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _prodListStreamCtrl.close();
  }
}
