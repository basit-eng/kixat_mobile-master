import 'package:schoolapp/model/WishListResponse.dart';
import 'package:schoolapp/model/requestbody/FormValuesRequestBody.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class WishListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<WishListResponse> fetchWishlistItem() async {
    final response = await _helper.get(Endpoints.getWishList);
    return WishListResponse.fromJson(response);
  }

  Future<WishListResponse> updateWishlistItem(
      FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.updateWishList, reqBody);
    return WishListResponse.fromJson(response);
  }

  Future<WishListResponse> moveItemToCart(FormValuesRequestBody reqBody) async {
    final response =
        await _helper.post(Endpoints.moveToCartFromWishList, reqBody);
    return WishListResponse.fromJson(response);
  }
}
