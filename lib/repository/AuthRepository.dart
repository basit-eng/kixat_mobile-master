import 'package:softify/model/ChangePasswordResponse.dart';
import 'package:softify/model/GetAvatarResponse.dart';
import 'package:softify/model/LoginFormResponse.dart';
import 'package:softify/model/PasswordRecoveryResponse.dart';
import 'package:softify/model/RegisterFormResponse.dart';
import 'package:softify/model/UserLoginResponse.dart';
import 'package:softify/model/requestbody/RegistrationReqBody.dart';
import 'package:softify/model/requestbody/UserLoginReqBody.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/repository/BaseRepository.dart';
import 'package:softify/utils/AppConstants.dart';

class AuthRepository extends BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<LoginFormResponse> getLoginFormData() async {
    final response = await _helper.get(Endpoints.userLogin);
    return LoginFormResponse.fromJson(response);
  }

  Future<UserLoginResponse> postLoginFormData(UserLoginReqBody reqBody) async {
    final response = await _helper.post(Endpoints.userLogin, reqBody);
    return UserLoginResponse.fromJson(response);
  }

  Future<String> performLogout() async {
    final response = await _helper.get(Endpoints.userLogout);
    return response.toString();
  }

  Future<RegisterFormResponse> getRegisterFormData() async {
    final response = await _helper.get(Endpoints.userRegister);
    return RegisterFormResponse.fromJson(response);
  }

  Future<RegisterFormResponse> postRegisterFormData(
      RegistrationReqBody reqBody) async {
    final response = await _helper.post(Endpoints.userRegister, reqBody);
    return RegisterFormResponse.fromJson(response);
  }

  Future<RegisterFormResponse> getCustomerInfo() async {
    final response = await _helper.get(Endpoints.customerInfo);
    return RegisterFormResponse.fromJson(response);
  }

  Future<RegisterFormResponse> updateCustomerInfo(
      RegistrationReqBody reqBody) async {
    final response = await _helper.post(Endpoints.customerInfo, reqBody);
    return RegisterFormResponse.fromJson(response);
  }

  Future<PasswordRecoveryResponse> postPasswordRecoverRequest(
      PasswordRecoveryResponse reqBody) async {
    final response = await _helper.post(Endpoints.passwordRecovery, reqBody);
    return PasswordRecoveryResponse.fromJson(response);
  }

  Future<ChangePasswordResponse> getChangePassForm() async {
    final response = await _helper.get(Endpoints.passwordChange);
    return ChangePasswordResponse.fromJson(response);
  }

  Future<ChangePasswordResponse> postChangePassForm(
      ChangePasswordResponse reqBody) async {
    final response = await _helper.post(Endpoints.passwordChange, reqBody);
    return ChangePasswordResponse.fromJson(response);
  }

  Future<GetAvatarResponse> fetchAvatar() async {
    final response = await _helper.get(Endpoints.getAvatar);
    return GetAvatarResponse.fromJson(response);
  }

  Future<GetAvatarResponse> removeAvatar() async {
    final response = await _helper.post(
        Endpoints.removeAvatar, AppConstants.EMPTY_POST_BODY);
    return GetAvatarResponse.fromJson(response);
  }

  Future<GetAvatarResponse> uploadAvatar(String filePath) async {
    final response = await _helper.multipart(
      Endpoints.uploadAvatar,
      filePath,
    );
    return GetAvatarResponse.fromJson(response);
  }
}
