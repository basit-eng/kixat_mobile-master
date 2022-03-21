import 'package:softify/model/SubscriptionListResponse.dart';
import 'package:softify/model/requestbody/FormValuesRequestBody.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';

class SubscriptionRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SubscriptionListResponse> fetchSubscriptions(num pageNumber) async {
    final response =
        await _helper.get('${Endpoints.customerSubscriptions}/$pageNumber');
    return SubscriptionListResponse.fromJson(response);
  }

  Future<SubscriptionListResponse> unsubscribe(
      FormValuesRequestBody reqBody) async {
    final response =
        await _helper.post(Endpoints.customerSubscriptions, reqBody);
    return SubscriptionListResponse.fromJson(response);
  }
}
