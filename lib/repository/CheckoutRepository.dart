import 'package:schoolapp/model/GetBillingAddressResponse.dart';
import 'package:schoolapp/model/SaveBillingResponse.dart';
import 'package:schoolapp/model/requestbody/FormValuesRequestBody.dart';
import 'package:schoolapp/model/requestbody/OrderSummaryReponse.dart';
import 'package:schoolapp/model/requestbody/SaveBillingReqBody.dart';
import 'package:schoolapp/model/requestbody/SavePaymentReqBody.dart';
import 'package:schoolapp/model/requestbody/SaveShippingReqBody.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';
import 'package:schoolapp/repository/BaseRepository.dart';

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
