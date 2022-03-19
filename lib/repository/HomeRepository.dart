import 'package:schoolapp/model/home/BestSellerProductResponse.dart';
import 'package:schoolapp/model/home/CategoriesWithProductsResponse.dart';
import 'package:schoolapp/model/home/FeaturedProductResponse.dart';
import 'package:schoolapp/model/HomeSliderResponse.dart';
import 'package:schoolapp/model/home/ManufacturersResponse.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class HomeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<HomeSliderResponse> fetchHomePageSliders() async {
    final response = await _helper.get(Endpoints.homePageBanner);
    return HomeSliderResponse.fromJson(response);
  }

  Future<FeaturedProductResponse> fetchFeaturedProducts() async {
    final response = await _helper.get(Endpoints.homeFeaturedProduct);
    return FeaturedProductResponse.fromJson(response);
  }

  Future<BestSellerProductResponse> fetchBestSellerProducts() async {
    final response = await _helper.get(Endpoints.homeBestsellerProducts);
    return BestSellerProductResponse.fromJson(response);
  }

  Future<CategoriesWithProductsResponse> fetchCategoriesWithProducts() async {
    final response = await _helper.get(Endpoints.homeCategoryWithProducts);
    return CategoriesWithProductsResponse.fromJson(response);
  }

  Future<ManufacturersResponse> fetchManufacturers() async {
    final response = await _helper.get(Endpoints.homeManufacturers);
    return ManufacturersResponse.fromJson(response);
  }
}
