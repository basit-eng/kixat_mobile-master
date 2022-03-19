import 'package:schoolapp/model/category_tree/CategoryTreeResponse.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class CategoryTreeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryTreeResponse> fetchCategoryTree() async {
    final response = await _helper.get(Endpoints.categoryTree);
    return CategoryTreeResponse.fromJson(response);
  }
}
