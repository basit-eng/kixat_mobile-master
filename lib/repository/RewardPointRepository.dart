import 'package:softify/model/RewardPointResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';

class RewardPointRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RewardPointResponse> fetchRawardPointDetails(num pageNumber) async {
    final response = await _helper.get('${Endpoints.rewardPoints}/$pageNumber');
    return RewardPointResponse.fromJson(response);
  }
}
