import 'package:kixat/model/SubscriptionListResponse.dart';
import 'package:kixat/model/requestbody/FormValuesRequestBody.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class SubscriptionRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<SubscriptionListResponse> fetchSubscriptions(num pageNumber) async {
    final response = await _helper.get('${Endpoints.customerSubscriptions}/$pageNumber');
    return SubscriptionListResponse.fromJson(response);
  }

  Future<SubscriptionListResponse> unsubscribe(FormValuesRequestBody reqBody) async {
    final response = await _helper.post(Endpoints.customerSubscriptions, reqBody);
    return SubscriptionListResponse.fromJson(response);
  }
}