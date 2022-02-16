import 'dart:async';

import 'package:kixat/bloc/base_bloc.dart';
import 'package:kixat/model/AvailableOption.dart';
import 'package:kixat/model/GetAvatarResponse.dart';
import 'package:kixat/model/RegisterFormResponse.dart';
import 'package:kixat/model/requestbody/FormValue.dart';
import 'package:kixat/model/requestbody/RegistrationReqBody.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/repository/AuthRepository.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/extensions.dart';
import 'package:kixat/utils/utility.dart';

class RegisterBloc extends BaseBloc {
  AuthRepository _repository;
  StreamController _scGetReg, _scPostReg, _scStates, _scFileUpload;

  AvailableOption selectedCountry, selectedState, selectedTimeZone;
  DateTime userDob;
  bool privacyAccepted;

  StreamSink<ApiResponse<RegisterFormData>> get registerFormSink =>
      _scGetReg.sink;
  Stream<ApiResponse<RegisterFormData>> get registerFormStream =>
      _scGetReg.stream;

  StreamSink<ApiResponse<RegisterFormResponse>> get registerResponseSink =>
      _scPostReg.sink;
  Stream<ApiResponse<RegisterFormResponse>> get registerResponseStream =>
      _scPostReg.stream;

  StreamSink<ApiResponse<List<AvailableOption>>> get statesListSink =>
      _scStates.sink;
  Stream<ApiResponse<List<AvailableOption>>> get statesListStream =>
      _scStates.stream;

  StreamSink<ApiResponse<GetAvatarData>> get avatarSink => _scFileUpload.sink;
  Stream<ApiResponse<GetAvatarData>> get avatarStream => _scFileUpload.stream;

  RegisterFormData cachedData;

  RegisterBloc() {
    _scGetReg = StreamController<ApiResponse<RegisterFormData>>();
    _scPostReg = StreamController<ApiResponse<RegisterFormResponse>>();
    _scStates = StreamController<ApiResponse<List<AvailableOption>>>();
    _scFileUpload = StreamController<ApiResponse<GetAvatarData>>();
    _repository = AuthRepository();
  }

  fetchRegisterFormData() async {
    registerFormSink.add(
      ApiResponse.loading(GlobalService().getString(Const.COMMON_PLEASE_WAIT)),
    );

    try {
      RegisterFormResponse response = await _repository.getRegisterFormData();
      setInitiallySelectedItems(response.data);
      cachedData = response.data;
      registerFormSink.add(ApiResponse.completed(cachedData));
    } catch (e) {
      cachedData = null;
      registerFormSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  postRegisterFormData(RegisterFormData data, List<FormValue> formValues) async {
    RegistrationReqBody reqBody = RegistrationReqBody(data: data.copyWith(availableStates: []), formValues: formValues);

    registerResponseSink.add(ApiResponse.loading(
        GlobalService().getString(Const.COMMON_PLEASE_WAIT)));

    try {
      RegisterFormResponse response = await _repository.postRegisterFormData(reqBody);
      registerResponseSink.add(ApiResponse.completed(response));
    } catch (e) {
      registerResponseSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchCustomerInfo() async {
    registerFormSink.add(
      ApiResponse.loading(GlobalService().getString(Const.COMMON_PLEASE_WAIT)),
    );

    try {
      RegisterFormResponse response = await _repository.getCustomerInfo();
      setInitiallySelectedItems(response.data);
      cachedData = response.data;
      registerFormSink.add(ApiResponse.completed(cachedData));
    } catch (e) {
      cachedData = null;
      registerFormSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  posCustomerInfo(RegisterFormData data, List<FormValue> formValues) async {
    RegistrationReqBody reqBody = RegistrationReqBody(data: data.copyWith(availableStates: []), formValues: formValues);

    registerResponseSink.add(ApiResponse.loading());

    try {
      RegisterFormResponse response = await _repository.updateCustomerInfo(reqBody);
      registerResponseSink.add(ApiResponse.completed(response));
    } catch (e) {
      registerResponseSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchStatesByCountryId(int countryId) async {
    statesListSink.add(ApiResponse.loading(''));

    try {
      var stateList = await fetchStatesList(countryId);

      this.cachedData.availableStates = stateList;

      registerFormSink.add(ApiResponse.completed(cachedData));
      statesListSink.add(ApiResponse.completed(stateList));
    } catch (e) {
      this.cachedData.availableStates = List<AvailableOption>.empty();

      registerFormSink.add(ApiResponse.completed(cachedData));
      statesListSink.add(ApiResponse.completed(List<AvailableOption>.empty()));
      print(e);
    }
  }

  fetchCustomerAvatar() async {
    avatarSink.add(ApiResponse.loading());

    try {
      GetAvatarResponse response = await _repository.fetchAvatar();
      avatarSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      avatarSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  removeAvatar() async {
    try {
      GetAvatarResponse response = await _repository.removeAvatar();
      avatarSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      avatarSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  uploadAvatar(String filePath) async {
    // avatarSink.add(ApiResponse.loading());

    try {
      await _repository.removeAvatar();
      GetAvatarResponse response = await _repository.uploadAvatar(filePath);
      avatarSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      avatarSink.add(ApiResponse.error(e.toString()));
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _scGetReg?.close();
    _scPostReg?.close();
    _scStates?.close();
    _scFileUpload?.close();
  }

  setInitiallySelectedItems(RegisterFormData formData) {

    if(selectedCountry!=null || selectedState!=null || selectedTimeZone!=null)
      return;

    selectedCountry = formData.availableCountries?.safeFirstWhere(
      (element) => element.selected ?? false,
      orElse: () => formData.availableCountries?.safeFirst(),
    );

    selectedState = formData.availableStates?.safeFirstWhere(
          (element) => element.selected ?? false,
      orElse: () => formData.availableStates?.safeFirst(),
    );

    selectedTimeZone = formData.availableTimeZones.safeFirstWhere(
      (element) => element.selected ?? false,
      orElse: () => formData.availableTimeZones?.safeFirst(),
    );

    if(formData.dateOfBirthDay == null || formData.dateOfBirthMonth == null || formData.dateOfBirthYear == null) {
      userDob = null;
    } else {
      userDob = DateTime(formData.dateOfBirthYear, formData.dateOfBirthMonth, formData.dateOfBirthDay);
    }

    privacyAccepted = false;
  }

}