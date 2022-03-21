import 'package:softify/model/NewProductResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';

class NewProductRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<NewProductResponse> fetchNewProducts() async {
    final response = await _helper.get(Endpoints.newProducts);
    return NewProductResponse.fromJson(response);
  }
}
