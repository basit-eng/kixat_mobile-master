import 'package:flutter/material.dart';
import 'package:kixat/ScopedModelWrapper.dart';
import 'package:kixat/utils/sign_config.dart';
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
          textTheme: ThemeData.dark().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'LatoRegular',
                    fontSize: 2.8 * SizeConfig.textMultiplier,
                    color: Colors.white
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
                fontSize: 2.8 * SizeConfig.textMultiplier,
              ),
              subtitle1: TextStyle(
                fontFamily: 'LatoRegular',
                color: Colors.white,
                fontSize: 1.7 * SizeConfig.textMultiplier,
              ),
              subtitle2: TextStyle(
                fontFamily: 'LatoRegular',
                fontSize: 1.7 * SizeConfig.textMultiplier,
              ),
              bodyText1: TextStyle(
                  fontFamily: 'LatoRegular',
                  fontSize: 1.6 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500),
              button: TextStyle(
                fontFamily: 'LatoRegular',
                fontSize: 2.2 * SizeConfig.textMultiplier,
              ),
            ),
        primaryIconTheme: ThemeData.dark().primaryIconTheme.copyWith(
              color: Colors.white,
              // parseColor(model.appLandingData.topBarTextColor),
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black38,
          // parseColor(model.appLandingData.bottomBarBackgroundColor),
          elevation: 10,
          selectedItemColor: Colors.blue,
          // parseColor(
          //     model.appLandingData.bottomBarActiveColor), // Need to set from api
          unselectedItemColor: Colors.white,
          // parseColor(model
          //     .appLandingData.bottomBarInactiveColor), // Need to set from api
          showUnselectedLabels: true,
        ),
        toggleableActiveColor: Colors.blue
        // getColorSwatch(parseColor(model.appLandingData.primaryThemeColor))[
        //     900], // checked checkbox color
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
          // backgroundColor: Colors.blue[800],
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'LatoRegular',
                    fontSize: 2.8 * SizeConfig.textMultiplier,
                    color: Colors.white
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
                fontSize: 2.8 * SizeConfig.textMultiplier,
              ),
              subtitle1: TextStyle(
                fontFamily: 'LatoRegular',
                color: Colors.grey[900],
                fontSize: 1.7 * SizeConfig.textMultiplier,
              ),
              subtitle2: TextStyle(
                fontFamily: 'LatoRegular',
                fontSize: 1.7 * SizeConfig.textMultiplier,
              ),
              bodyText1: TextStyle(
                  fontFamily: 'LatoRegular',
                  fontSize: 1.6 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500),
              button: TextStyle(
                fontFamily: 'LatoRegular',
                fontSize: 2.2 * SizeConfig.textMultiplier,
              ),
            ),
        primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
            // AppBar icon color
            color: Colors.white
            // parseColor(model.appLandingData.topBarTextColor),
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white70,
          // parseColor(model.appLandingData.bottomBarBackgroundColor),
          elevation: 10,
          selectedItemColor: Colors.blue,
          // parseColor(
          //     model.appLandingData.bottomBarActiveColor), // Need to set from api
          unselectedItemColor: Colors.black38,
          //  parseColor(model
          //     .appLandingData.bottomBarInactiveColor), // Need to set from api
          showUnselectedLabels: true,
        ),
        toggleableActiveColor: Colors.blue);
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

//---------------Style Config
// class AppTheme {
//   AppTheme._();

//   static const Color appBackgroundColor = Color(0xFFFFF7EC);
//   static const Color topBarBackgroundColor = Color(0xFFFFD974);
//   static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
//   static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
//   static const Color subTitleTextColor = Color(0xFF9F988F);

//   static final ThemeData lightTheme = ThemeData(
//     scaffoldBackgroundColor: AppTheme.appBackgroundColor,
//     brightness: Brightness.light,
//     textTheme: lightTextTheme,
//   );

//   static final ThemeData darkTheme = ThemeData(
//     scaffoldBackgroundColor: Colors.black,
//     brightness: Brightness.dark,
//     textTheme: darkTextTheme,
//   );

//   static final TextTheme lightTextTheme = TextTheme(
//     titleLarge: _titleLight,
//     titleMedium: _titleLight,
//     titleSmall: _titleLight,
//     subtitle1: _subTitleLight,
//     subtitle2: _subTitleLight,
//     button: _buttonLight,
//     displayLarge: _greetingLight,
//     displaySmall: _greetingLight,
//     displayMedium: _greetingLight,
//     bodyLarge: _selectedTabLight,
//     bodySmall: _selectedTabLight,
//     bodyMedium: _selectedTabLight,
//   );

//   static final TextTheme darkTextTheme = TextTheme(
//     titleLarge: _titleDark,
//     titleMedium: _titleDark,
//     titleSmall: _titleDark,
//     subtitle1: _subTitleLight,
//     subtitle2: _subTitleDark,
//     button: _buttonDark,
//     displayLarge: _greetingDark,
//     displaySmall: _greetingDark,
//     displayMedium: _greetingDark,
//     bodyLarge: _selectedTabDark,
//     bodySmall: _selectedTabDark,
//     bodyMedium: _selectedTabDark,
//   );

//   static final TextStyle _titleLight = TextStyle(
//     color: Colors.black,
//     fontSize: 3.5 * SizeConfig.textMultiplier,
//   );

//   static final TextStyle _subTitleLight = TextStyle(
//     color: subTitleTextColor,
//     fontSize: 2 * SizeConfig.textMultiplier,
//     height: 1.5,
//   );

//   static final TextStyle _buttonLight = TextStyle(
//     color: Colors.black,
//     fontSize: 2.5 * SizeConfig.textMultiplier,
//   );

//   static final TextStyle _greetingLight = TextStyle(
//     color: Colors.black,
//     fontSize: 2.0 * SizeConfig.textMultiplier,
//   );

//   static final TextStyle _searchLight = TextStyle(
//     color: Colors.black,
//     fontSize: 2.3 * SizeConfig.textMultiplier,
//   );

//   static final TextStyle _selectedTabLight = TextStyle(
//     color: Colors.black,
//     fontWeight: FontWeight.bold,
//     fontSize: 2 * SizeConfig.textMultiplier,
//   );

//   static final TextStyle _unSelectedTabLight = TextStyle(
//     color: Colors.grey,
//     fontSize: 2 * SizeConfig.textMultiplier,
//   );

//   static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

//   static final TextStyle _subTitleDark =
//       _subTitleLight.copyWith(color: Colors.white70);

//   static final TextStyle _buttonDark =
//       _buttonLight.copyWith(color: Colors.black);

//   static final TextStyle _greetingDark =
//       _greetingLight.copyWith(color: Colors.black);

//   static final TextStyle _searchDark =
//       _searchDark.copyWith(color: Colors.black);

//   static final TextStyle _selectedTabDark =
//       _selectedTabDark.copyWith(color: Colors.white);

//   static final TextStyle _unSelectedTabDark =
//       _selectedTabDark.copyWith(color: Colors.white70);
// }
