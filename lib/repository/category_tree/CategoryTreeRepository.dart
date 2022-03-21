import 'package:softify/model/category_tree/CategoryTreeResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';

class CategoryTreeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryTreeResponse> fetchCategoryTree() async {
    final response = await _helper.get(Endpoints.categoryTree);
    return CategoryTreeResponse.fromJson(response);
  }
}
