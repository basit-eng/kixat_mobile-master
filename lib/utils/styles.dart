import 'package:flutter/material.dart';
import 'package:kixat/ScopedModelWrapper.dart';
import 'package:kixat/utils/utility.dart';

class Styles {
  static ThemeData darkTheme(AppModel model) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(
        parseColorInt(model.appLandingData.primaryThemeColor),
        getColorSwatch(parseColor(model.appLandingData.primaryThemeColor)),
      ),
      primaryColor: getColorSwatch(
          parseColor(model.appLandingData.primaryThemeColor))[900],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'LatoRegular',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black54,
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'LatoRegular', fontSize: 20, color: Colors.white
                  // color: parseColor(model
                  //     .appLandingData.topBarTextColor), // Need to set from api
                  ),
            ),
        // color: parseColor(
        //     model.appLandingData.topBarBackgroundColor), // Need to set from api
      ),
      textTheme: ThemeData.dark().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'KhandBold',
              fontSize: 22,
            ),
            subtitle1: TextStyle(
              fontFamily: 'LatoRegular',
              color: Colors.grey[200],
              fontSize: 18,
            ),
            subtitle2: TextStyle(
              fontFamily: 'LatoRegular',
              fontSize: 16,
            ),
            bodyText2: TextStyle(
              fontFamily: 'LatoRegular',
              fontSize: 16,
            ),
            button: TextStyle(
              fontFamily: 'LatoRegular',
              fontSize: 15,
            ),
          ),
      primaryIconTheme: ThemeData.dark().primaryIconTheme.copyWith(
            color: Colors.white,
            // parseColor(model.appLandingData.topBarTextColor),
          ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            parseColor(model.appLandingData.bottomBarBackgroundColor),
        elevation: 10,
        selectedItemColor: parseColor(
            model.appLandingData.bottomBarActiveColor), // Need to set from api
        unselectedItemColor: parseColor(model
            .appLandingData.bottomBarInactiveColor), // Need to set from api
        showUnselectedLabels: true,
      ),
      toggleableActiveColor:
          getColorSwatch(parseColor(model.appLandingData.primaryThemeColor))[
              900], // checked checkbox color
    );
  }

  static ThemeData lightTheme(AppModel model) {
    return ThemeData(
      primarySwatch: MaterialColor(
        parseColorInt(model.appLandingData.primaryThemeColor),
        getColorSwatch(parseColor(model.appLandingData.primaryThemeColor)),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'LatoRegular',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[800],
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'LatoRegular', fontSize: 20, color: Colors.white
                  // color: parseColor(model
                  //     .appLandingData.topBarTextColor), // Need to set from api
                  ),
            ),
        // color: parseColor(
        // model.appLandingData.topBarBackgroundColor), // Need to set from api
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'KhandBold',
              fontSize: 22,
            ),
            subtitle1: TextStyle(
              fontFamily: 'LatoRegular',
              color: Colors.grey[800],
              fontSize: 18,
            ),
            subtitle2: TextStyle(
              fontFamily: 'LatoRegular',
              fontSize: 16,
            ),
            bodyText2: TextStyle(
              fontFamily: 'LatoRegular',
              fontSize: 16,
            ),
            button: TextStyle(
              fontFamily: 'LatoRegular',
              fontSize: 15,
            ),
          ),
      primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
          // AppBar icon color
          color: Colors.black
          // parseColor(model.appLandingData.topBarTextColor),
          ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            parseColor(model.appLandingData.bottomBarBackgroundColor),
        elevation: 10,
        selectedItemColor: parseColor(
            model.appLandingData.bottomBarActiveColor), // Need to set from api
        unselectedItemColor: parseColor(model
            .appLandingData.bottomBarInactiveColor), // Need to set from api
        showUnselectedLabels: true,
      ),
    );
  }

  static Color secondaryButtonColor = Color(0x2B2E43 + 0xFF000000);

  static TextStyle productNameTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 17.0,
        );
  }

  static TextStyle productPriceTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        );
  }

  static Color textColor(BuildContext context) {
    return isDarkThemeEnabled(context) ? Colors.grey[200] : Colors.grey[800];
  }
}
