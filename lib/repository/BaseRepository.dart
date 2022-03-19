import 'package:schoolapp/model/AddToCartResponse.dart';
import 'package:schoolapp/model/EstimateShippingResponse.dart';
import 'package:schoolapp/model/GetStatesResponse.dart';
import 'package:schoolapp/model/requestbody/EstimateShippingReqBody.dart';
import 'package:schoolapp/model/requestbody/FormValuesRequestBody.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<GetStatesResponse> getStatesByCountry(int countryId) async {
    final response =
        await _helper.get('${Endpoints.getStatesByCountry}/$countryId');
    return GetStatesResponse.fromJson(response);
  }

  Future<AddToCartResponse> addToCartFromProductBox(
      int productId, int cartType, FormValuesRequestBody reqBody) async {
    final response = await _helper.post(
      '${Endpoints.addToCartFromProductBox}/$productId/$cartType',
      reqBody,
    );
    return AddToCartResponse.fromJson(response);
  }

  Future<EstimateShippingResponse> estimateShipping(
      EstimateShippingReqBody reqBody) async {
    final response =
        await _helper.post(Endpoints.cartEstimateShipping, reqBody);
    return EstimateShippingResponse.fromJson(response);
  }

  Future<EstimateShippingResponse> productEstimateShipping(
      EstimateShippingReqBody reqBody) async {
    final response =
        await _helper.post(Endpoints.productEstimateShipping, reqBody);
    return EstimateShippingResponse.fromJson(response);
  }
}
