import 'dart:async';

import 'package:softify/model/product_list/ProductListResponse.dart';
import 'package:softify/networking/ApiResponse.dart';
import 'package:softify/repository/product_list/ProductListRepository.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';

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
