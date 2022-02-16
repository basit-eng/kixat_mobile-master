import 'dart:async';

import 'package:kixat/bloc/base_bloc.dart';
import 'package:kixat/model/home/BestSellerProductResponse.dart';
import 'package:kixat/model/home/CategoriesWithProductsResponse.dart';
import 'package:kixat/model/home/FeaturedProductResponse.dart';
import 'package:kixat/model/HomeSliderResponse.dart';
import 'package:kixat/model/home/ManufacturersResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/repository/HomeRepository.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';

class HomeBloc implements BaseBloc {
  HomeRepository _homeRepository;
  StreamController _sliderStreamController,
      _featureProductStreamController,
      _bestSellerProductsStreamCtrl,
      _categoriesWithProdStreamCtrl,
      _manufacturersStreamCtrl;

  // Slider stream
  StreamSink<ApiResponse<HomeSliderResponse>> get sliderSink =>
      _sliderStreamController.sink;
  Stream<ApiResponse<HomeSliderResponse>> get sliderStream =>
      _sliderStreamController.stream;

  // Featured products stream
  StreamSink<ApiResponse<FeaturedProductResponse>> get featuredProdSink =>
      _featureProductStreamController.sink;
  Stream<ApiResponse<FeaturedProductResponse>> get featuredProdStream =>
      _featureProductStreamController.stream;

  // Best seller products stream
  StreamSink<ApiResponse<BestSellerProductResponse>> get bestSellerProdSink =>
      _bestSellerProductsStreamCtrl.sink;
  Stream<ApiResponse<BestSellerProductResponse>> get bestSellerProdStream =>
      _bestSellerProductsStreamCtrl.stream;

  // Categories with products stream
  StreamSink<ApiResponse<CategoriesWithProductsResponse>>
      get categoriesWithProdSink => _categoriesWithProdStreamCtrl.sink;
  Stream<ApiResponse<CategoriesWithProductsResponse>>
      get categoriesWithProdStream => _categoriesWithProdStreamCtrl.stream;

  // Manufacturers stream controller
  StreamSink<ApiResponse<ManufacturersResponse>> get manufacturersSink =>
      _manufacturersStreamCtrl.sink;
  Stream<ApiResponse<ManufacturersResponse>> get manufacturersStream =>
      _manufacturersStreamCtrl.stream;

  HomeBloc() {
    _sliderStreamController =
        StreamController<ApiResponse<HomeSliderResponse>>();

    _featureProductStreamController =
        StreamController<ApiResponse<FeaturedProductResponse>>();

    _bestSellerProductsStreamCtrl =
        StreamController<ApiResponse<BestSellerProductResponse>>();

    _categoriesWithProdStreamCtrl =
        StreamController<ApiResponse<CategoriesWithProductsResponse>>();

    _manufacturersStreamCtrl =
        StreamController<ApiResponse<ManufacturersResponse>>();

    _homeRepository = HomeRepository();
  }

  fetchHomeBanners() async {
    sliderSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      HomeSliderResponse movies = await _homeRepository.fetchHomePageSliders();
      sliderSink.add(ApiResponse.completed(movies));
    } catch (e) {
      sliderSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  getFeaturedProducts() async {
    featuredProdSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var featuredProductResponse =
          await _homeRepository.fetchFeaturedProducts();
      featuredProdSink.add(ApiResponse.completed(featuredProductResponse));
    } catch (e) {
      featuredProdSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchBestSellerProducts() async {
    bestSellerProdSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var bestSellerProductsRes =
          await _homeRepository.fetchBestSellerProducts();
      bestSellerProdSink.add(ApiResponse.completed(bestSellerProductsRes));
    } catch (e) {
      bestSellerProdSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchCategoriesWithProducts() async {
    categoriesWithProdSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var categoriesWithProdsRes = await _homeRepository.fetchCategoriesWithProducts();

      // remove empty categories
      categoriesWithProdsRes.data.removeWhere((element)
        => element.products.isEmpty
      );

      categoriesWithProdSink.add(ApiResponse.completed(categoriesWithProdsRes));
    } catch (e) {
      categoriesWithProdSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchManufacturers() async {
    manufacturersSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      var manufacturersRes = await _homeRepository.fetchManufacturers();
      manufacturersSink.add(ApiResponse.completed(manufacturersRes));
    } catch (e) {
      manufacturersSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  dispose() {
    _sliderStreamController?.close();
    _featureProductStreamController?.close();
    _bestSellerProductsStreamCtrl?.close();
    _categoriesWithProdStreamCtrl?.close();
    _manufacturersStreamCtrl?.close();
  }
}
