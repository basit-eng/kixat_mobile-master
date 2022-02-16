import 'dart:async';

import 'package:kixat/bloc/base_bloc.dart';
import 'package:kixat/model/NewProductResponse.dart';
import 'package:kixat/model/ProductSummary.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/repository/NewProductRepository.dart';

class NewProductBloc extends BaseBloc {
  NewProductRepository _repository;
  StreamController _scProducts, _loaderSink;

  StreamSink<ApiResponse<List<ProductSummary>>> get productSink => _scProducts.sink;
  Stream<ApiResponse<List<ProductSummary>>> get productStream => _scProducts.stream;

  StreamSink<ApiResponse<bool>> get loaderSink => _loaderSink.sink;
  Stream<ApiResponse<bool>> get loaderStream => _loaderSink.stream;

  NewProductBloc() {
    _repository = NewProductRepository();
    _scProducts = StreamController<ApiResponse<List<ProductSummary>>>();
    _loaderSink = StreamController<ApiResponse<bool>>();
  }

  @override
  void dispose() {
    _scProducts?.close();
    _loaderSink?.close();
  }

  fetchNewProducts() async {
    productSink.add(ApiResponse.loading());

    try {
      NewProductResponse response = await _repository.fetchNewProducts();
      productSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      productSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

}