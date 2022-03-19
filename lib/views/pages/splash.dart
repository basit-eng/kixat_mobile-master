import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolapp/ScopedModelWrapper.dart';
import 'package:schoolapp/networking/AppException.dart';
import 'package:schoolapp/repository/SettingsRepository.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/AppConstants.dart';
import 'package:schoolapp/utils/utility.dart';
import 'package:schoolapp/views/pages/tabs-screen/error_screen.dart';
import 'package:schoolapp/views/pages/tabs-screen/tabs_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SettingsRepository repository = SettingsRepository();

  @override
  void initState() {
    super.initState();
    getAppLandingData();
    print("Splash initState");
  }

  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    ScreenUtil.init(
      context,
      designSize: Size(
        ScreenSize.width,
        ScreenSize.height,
      ),
      allowFontScaling: true,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                // image: AssetImage(AppConstants.splashBackground),
                fit: BoxFit.cover)),
        // child: Center(
        //   child: Image.asset(
        // 'assets/app_logo.png',
        // fit: BoxFit.scaleDown,
        //)),
      ),
    );
  }

  getAppLandingData() async {
    await prepareSessionData();

    repository.fetchAppLandingSettings().then((value) {
      GlobalService().setAppLandingData(value.data);

      // Settings the value on ScopedModel
      AppModel model = ScopedModel.of(context);
      model.updateAppLandingData(value.data);

      Navigator.pushReplacementNamed(context, TabsScreen.routeName);
    }).onError((error, stackTrace) {
      // go to error page
      Navigator.of(context)
          .pushNamed(
            ErrorScreen.routeName,
            arguments: ErrorScreenArguments(
              errorMsg: error.toString(),
              errorCode: error is AppException ? error.getErrorCode() : 0,
            ),
          )
          .then((shouldReload) => {
                if (shouldReload == 'retry')
                  getAppLandingData()
                else
                  // TODO check whether it works on iOS too
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop')
              });
    });
  }
}
