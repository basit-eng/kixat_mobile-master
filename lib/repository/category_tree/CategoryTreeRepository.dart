import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class CategoryTreeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryTreeResponse> fetchCategoryTree() async {
    final response = await _helper.get(Endpoints.categoryTree);
    return CategoryTreeResponse.fromJson(response);
  }
}
