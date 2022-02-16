import 'package:kixat/model/AddToCartResponse.dart';
import 'package:kixat/model/EstimateShippingResponse.dart';
import 'package:kixat/model/GetStatesResponse.dart';
import 'package:kixat/model/requestbody/EstimateShippingReqBody.dart';
import 'package:kixat/model/requestbody/FormValuesRequestBody.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<GetStatesResponse> getStatesByCountry(int countryId) async {
    final response = await _helper.get('${Endpoints.getStatesByCountry}/$countryId');
    return GetStatesResponse.fromJson(response);
  }

  Future<AddToCartResponse> addToCartFromProductBox(int productId, int cartType, FormValuesRequestBody reqBody) async {
    final response = await _helper.post(
      '${Endpoints.addToCartFromProductBox}/$productId/$cartType',
      reqBody,
    );
    return AddToCartResponse.fromJson(response);
  }

  Future<EstimateShippingResponse> estimateShipping(EstimateShippingReqBody reqBody) async {
    final response = await _helper.post(Endpoints.cartEstimateShipping, reqBody);
    return EstimateShippingResponse.fromJson(response);
  }

  Future<EstimateShippingResponse> productEstimateShipping(EstimateShippingReqBody reqBody) async {
    final response = await _helper.post(Endpoints.productEstimateShipping, reqBody);
    return EstimateShippingResponse.fromJson(response);
  }
}