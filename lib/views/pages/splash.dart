import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kixat/ScopedModelWrapper.dart';
import 'package:kixat/networking/AppException.dart';
import 'package:kixat/repository/SettingsRepository.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/AppConstants.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/pages/tabs-screen/error_screen.dart';
import 'package:kixat/views/pages/tabs-screen/tabs_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConstants.splashBackground),
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
