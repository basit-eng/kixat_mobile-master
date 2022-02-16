import 'package:kixat/model/SearchResponse.dart';
import 'package:kixat/model/SearchSuggestionResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class SearchRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SearchResponse> searchProduct(Map<String, String> queryParams,) async {
    String queryString = Uri(queryParameters: queryParams).query;

    final response = await _helper.get('${Endpoints.search}?$queryString');
    return SearchResponse.fromJson(response);
  }

  Future<SearchSuggestionResponse> fetchSuggestions(String query) async {
    final response = await _helper.get('${Endpoints.searchAutocomplete}?term=$query');
    return SearchSuggestionResponse.fromJson(response);
  }
}
