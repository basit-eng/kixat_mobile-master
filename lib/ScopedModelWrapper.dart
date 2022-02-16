import 'package:flutter/material.dart';
import 'package:kixat/main.dart';
import 'package:kixat/model/AppLandingResponse.dart';
import 'package:kixat/utils/shared_pref.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/AppLandingResponse.dart';

class ScopeModelWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(model: AppModel(), child: MyApp());
  }
}

class AppModel extends Model {
  // Set All default values here
  AppLandingData _appLandingData = AppLandingData(
    primaryThemeColor: '#10CB3C',
    bottomBarActiveColor: '#10CB3C',
    bottomBarInactiveColor: '#808080',
    bottomBarBackgroundColor: '#f7f6f6',
    topBarTextColor: '#ffffff',
    topBarBackgroundColor: '#ffffff',
    totalShoppingCartProducts: 0,
    totalWishListProducts: 0,
    // rtl: true,
    rtl: false,
  );
  int _cartCount = 0;
  bool _darkTheme = false;

  AppLandingData get appLandingData => _appLandingData;
  int get getCartCount => _cartCount;
  bool get isDarkTheme => _darkTheme;

  void updateAppLandingData(AppLandingData newData) {
    _appLandingData = newData;
    _cartCount = newData?.totalShoppingCartProducts ?? 0;
    SessionData().isDarkTheme().then((isEnabled) {
      _darkTheme = isEnabled;
      notifyListeners();
    });
  }

  void seThemeMode(bool isDarkEnable) {
    debugPrint('DarkTheme Enabled -- $isDarkTheme');
    _darkTheme = isDarkEnable;
    notifyListeners();
  }

  void updateCartCount(int count) {
    debugPrint('ScopedModel -- set cart count to $count');
    _cartCount = count;
    notifyListeners();
  }
}
