import 'package:softify/model/product_list/ProductListResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/utils/GetBy.dart';

class ProductListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProductListResponse> fetchProductList(
      String type, int categoryId, Map<String, String> queryParams) async {
    String endpoint;
    switch (type) {
      case GetBy.CATEGORY:
        {
          endpoint = Endpoints.productListCategoryTree;
        }
        break;

      case GetBy.MANUFACTURER:
        {
          endpoint = Endpoints.productListManufacturer;
        }
        break;

      case GetBy.TAG:
        {
          endpoint = Endpoints.productListTag;
        }
        break;

      case GetBy.VENDOR:
        {
          endpoint = Endpoints.productListVendor;
        }
        break;
    }

    String queryString = Uri(queryParameters: queryParams).query;

    final response = await _helper.get('$endpoint/$categoryId?$queryString');
    return ProductListResponse.fromJson(response);
  }
}
