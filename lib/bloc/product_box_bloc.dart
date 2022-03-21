import 'package:softify/model/AddToCartResponse.dart';
import 'package:softify/model/requestbody/FormValue.dart';
import 'package:softify/model/requestbody/FormValuesRequestBody.dart';
import 'package:softify/networking/ApiResponse.dart';
import 'package:softify/repository/BaseRepository.dart';
import 'package:softify/utils/AppConstants.dart';

class ProductBoxBloc {
  BaseRepository _repository;

  ProductBoxBloc() {
    _repository = BaseRepository();
  }

  Future<ApiResponse<AddToCartResponse>> addToCart(
      num productId, bool isCart) async {
    FormValuesRequestBody reqBody = FormValuesRequestBody(formValues: [
      FormValue(
        key: 'addtocart_$productId.EnteredQuantity',
        value: '1',
      ),
    ]);

    try {
      AddToCartResponse response = await _repository.addToCartFromProductBox(
          productId,
          isCart ? AppConstants.typeShoppingCart : AppConstants.typeWishList,
          reqBody);

      return ApiResponse.completed(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
