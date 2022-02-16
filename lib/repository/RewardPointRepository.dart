import 'package:kixat/model/RewardPointResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class RewardPointRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RewardPointResponse> fetchRawardPointDetails(num pageNumber) async {
    final response = await _helper.get('${Endpoints.rewardPoints}/$pageNumber');
    return RewardPointResponse.fromJson(response);
  }
}