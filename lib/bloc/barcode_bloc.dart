import 'dart:async';

import 'package:flutter/material.dart';
import 'package:softify/bloc/base_bloc.dart';
import 'package:softify/model/ProductDetailsResponse.dart';
import 'package:softify/networking/ApiResponse.dart';
import 'package:softify/repository/ProductDetailsRepository.dart';

class BarcodeBloc implements BaseBloc {
  ProductDetailsRepository _repository;
  StreamController _scProdDetails;

  StreamSink<ApiResponse<ProductDetails>> get prodDetailsSink =>
      _scProdDetails.sink;
  Stream<ApiResponse<ProductDetails>> get prodDetailsStream =>
      _scProdDetails.stream;

  BarcodeBloc() {
    _scProdDetails = StreamController<ApiResponse<ProductDetails>>();
    _repository = ProductDetailsRepository();
  }

  @override
  void dispose() {
    _scProdDetails?.close();
  }

  fetchProductByBarcode(String barcode) async {
    prodDetailsSink.add(ApiResponse.loading());

    try {
      ProductDetailsResponse response =
          await _repository.fetchProductByBarcode(barcode);
      prodDetailsSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      prodDetailsSink.add(ApiResponse.error(e.toString()));
      debugPrint(e.toString());
    }
  }
}
