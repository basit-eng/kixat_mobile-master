import 'package:kixat/model/NewProductResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class NewProductRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<NewProductResponse> fetchNewProducts() async {
    final response = await _helper.get(Endpoints.newProducts);
    return NewProductResponse.fromJson(response);
  }
}