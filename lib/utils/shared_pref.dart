import 'dart:convert';

import 'package:schoolapp/model/UserLoginResponse.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  static const _keyLoggedIn = '_keyLoggedIn';
  static const _keyAuthToken = '_keyAuthToken';
  static const _keyDeviceId = '_keyDeviceId';
  static const _keyCustomerInfo = '_keyCustomerInfo';
  static const _keyDarkTheme = '_keyDarkTheme';

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken) ?? "";
  }

  Future<void> clearUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('_keyLoggedIn');
    await prefs.remove('_keyAuthToken');
    await prefs.remove('_keyCustomerInfo');

    GlobalService().setAuthToken("");

    return;
  }

  Future<void> setUserSession(String authToken,
      [CustomerInfo customerInfo]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyAuthToken, authToken);

    if (customerInfo != null) {
      await prefs.setString(_keyCustomerInfo, jsonEncode(customerInfo));
    }

    GlobalService().setAuthToken(authToken);

    return; // success
  }

  Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceId) ?? "";
  }

  void setDeviceId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyDeviceId, id);
  }

  Future<CustomerInfo> getCustomerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var info = prefs.getString(_keyCustomerInfo);

    try {
      return CustomerInfo.fromJson(jsonDecode(info));
    } catch (e) {
      return null;
    }
  }

  void setCustomerInfo(CustomerInfo info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCustomerInfo, jsonEncode(info));
  }

  Future<bool> isDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkTheme) ?? false;
  }

  Future<bool> setDarkTheme(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyDarkTheme, isEnabled);
  }
}
