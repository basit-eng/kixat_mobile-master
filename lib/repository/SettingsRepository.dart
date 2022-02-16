import 'dart:io';

import 'package:kixat/model/AppLandingResponse.dart';
import 'package:kixat/model/BaseResponse.dart';
import 'package:kixat/model/requestbody/AppStartReqBody.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class SettingsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AppLandingResponse> fetchAppLandingSettings() async {
    final response = await _helper.get(Endpoints.appLandingSettings);
    return AppLandingResponse.fromJson(response);
  }

  Future<BaseResponse> postFcmToken(String fcmToken) async {

    num deviceTypeId;

    if(Platform.isAndroid)
      deviceTypeId = 10;
    else if(Platform.isIOS)
      deviceTypeId = 5;
    else
      deviceTypeId = 20;

    final response = await _helper.post(Endpoints.appStart, AppStartReqBody(
      data: AppStartData(
        deviceTypeId: deviceTypeId, // Android
        subscriptionId: fcmToken,
      )
    ));
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> changeLanguage(int languageId) async {
    final response = await _helper.get('${Endpoints.setLanguage}/$languageId');
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> changeCurrency(int currencyId) async {
    final response = await _helper.get('${Endpoints.setCurrency}/$currencyId');
    return BaseResponse.fromJson(response);
  }
}
