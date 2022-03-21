import 'package:softify/model/GetBillingAddressResponse.dart';
import 'package:softify/model/SaveBillingResponse.dart';
import 'package:softify/model/requestbody/FormValuesRequestBody.dart';
import 'package:softify/model/requestbody/OrderSummaryReponse.dart';
import 'package:softify/model/requestbody/SaveBillingReqBody.dart';
import 'package:softify/model/requestbody/SavePaymentReqBody.dart';
import 'package:softify/model/requestbody/SaveShippingReqBody.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/repository/BaseRepository.dart';

class CheckoutRepository extends BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<GetBillingAddressResponse> fetchBillingAddress() async {
    final response = await _helper.get(Endpoints.getBilling);
    return GetBillingAddressResponse.fromJson(response);
  }

  Future<CheckoutPostResponse> saveBillingAddress(
      SaveBillingReqBody reqBody) async {
    final response = await _helper.post(Endpoints.saveBilling, reqBody);
    return CheckoutPostResponse.fromJson(response);
  }

  Future<CheckoutPostResponse> saveShippingAddress(
      SaveShippingReqBody reqBody) async {
    final response = await _helper.post(Endpoints.saveShippingAddress, reqBody);
    return CheckoutPostResponse.fromJson(response);
  }

  Future<CheckoutPostResponse> saveShippingMethod(
      FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.saveShippingMethod, reqBody);
    return CheckoutPostResponse.fromJson(response);
  }

  Future<CheckoutPostResponse> savePaymentMethod(
      SavePaymentReqBody reqBody) async {
    final response = await _helper.post(Endpoints.savePaymentMethod, reqBody);
    return CheckoutPostResponse.fromJson(response);
  }

  Future<OrderSummaryResponse> getConfirmOrder() async {
    final response = await _helper.get(Endpoints.confirmOrder);
    return OrderSummaryResponse.fromJson(response);
  }

  Future<CheckoutPostResponse> confirmOrder() async {
    final response = await _helper.post(Endpoints.confirmOrder, '');
    return CheckoutPostResponse.fromJson(response);
  }

  Future<CheckoutPostResponse> orderComplete() async {
    final response = await _helper.get(Endpoints.orderComplete);
    return CheckoutPostResponse.fromJson(response);
  }
}
