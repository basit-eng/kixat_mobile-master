import 'package:schoolapp/model/RewardPointResponse.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';

class RewardPointRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RewardPointResponse> fetchRawardPointDetails(num pageNumber) async {
    final response = await _helper.get('${Endpoints.rewardPoints}/$pageNumber');
    return RewardPointResponse.fromJson(response);
  }
}
