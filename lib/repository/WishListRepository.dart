import 'package:softify/model/WishListResponse.dart';
import 'package:softify/model/requestbody/FormValuesRequestBody.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';

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
