import 'dart:async';

import 'package:flutter/material.dart';
import 'package:softify/model/AppLandingResponse.dart';

class GlobalService {
  static final GlobalService _instance = GlobalService._internal();

  AppLandingData _appLandingData;
  String _deviceId, _authToken, _fcmToken;
  Map<String, String> _stringResourceMap;
  int _cartCount, _wishListCount;
  StreamController _scCart, _scWishList;

  StreamSink<int> get cartCountSink => _scCart.sink;
  Stream<int> get cartCountStream => _scCart.stream;

  StreamSink<int> get wishlistCountSink => _scWishList.sink;
  Stream<int> get wishlistCountStream => _scWishList.stream;

  // passes the instantiation to the _instance object
  factory GlobalService() => _instance;

  GlobalService._internal() {
    _deviceId = '';
    _authToken = '';
    _fcmToken = '';
    _cartCount = 0;
    _wishListCount = 0;
    _stringResourceMap = {};
    _scCart = StreamController<int>.broadcast();
    _scWishList = StreamController<int>.broadcast();
  }

  dispose() {
    _scCart?.close();
    _scWishList?.close();
  }

  String getString(String key) => _stringResourceMap[key] ?? key;

  String getStringWithNumber(String key, num value) =>
      getString(key).replaceFirst("{0}", value.toString());

  String getStringWithNumberStr(String key, String value) =>
      getString(key).replaceFirst("{0}", value);

  AppLandingData getAppLandingData() => _appLandingData;

  void setAppLandingData(AppLandingData value) {
    _appLandingData = value;
    _cartCount = value.totalShoppingCartProducts ?? 0;
    _wishListCount = value.totalWishListProducts ?? 0;
    cartCountSink.add(_cartCount);
    wishlistCountSink.add(_wishListCount);
    debugPrint('ScopedModel -- cart-$_cartCount wl-$_wishListCount');

    _appLandingData.stringResources.forEach((e) {
      _stringResourceMap[e.key] = e.value;
    });
  }

  void setDeviceId(String id) => _deviceId = id;

  String getDeviceId() => _deviceId;

  void setAuthToken(String token) => _authToken = token;

  String getAuthToken() => _authToken;

  bool isLoggedIn() => _authToken.isNotEmpty;

  void setFcmToken(String token) => _fcmToken = token;

  String getFcmToken() => _fcmToken;

  int get getCartCount => _cartCount;

  void updateCartCount(int count) {
    debugPrint('ScopedModel -- set cart count to $count');
    _appLandingData.totalShoppingCartProducts = count;

    if (count != _cartCount) {
      _cartCount = count;
      cartCountSink.add(count);
    }
  }

  int get getWishListCount => _wishListCount;

  void updateWishListCount(int count) {
    debugPrint('ScopedModel -- set wishList count to $count');
    _appLandingData.totalWishListProducts = count;

    if (count != _wishListCount) {
      _wishListCount = count;
      wishlistCountSink.add(count);
    }
  }
}
