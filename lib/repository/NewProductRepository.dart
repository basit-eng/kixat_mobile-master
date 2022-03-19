import 'package:schoolapp/model/NewProductResponse.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class NewProductRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<NewProductResponse> fetchNewProducts() async {
    final response = await _helper.get(Endpoints.newProducts);
    return NewProductResponse.fromJson(response);
  }
}
