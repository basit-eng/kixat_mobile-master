import 'package:flutter/material.dart';
import 'package:schoolapp/ScopedModelWrapper.dart';
import 'package:schoolapp/bloc/settings_bloc.dart';
import 'package:schoolapp/views/customWidget/CustomAppBar.dart';
import 'package:schoolapp/views/customWidget/CustomDropdown.dart';
import 'package:schoolapp/views/customWidget/loading_dialog.dart';
import 'package:schoolapp/model/AppLandingResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/shared_pref.dart';
import 'package:schoolapp/utils/utility.dart';
import 'package:schoolapp/utils/extensions.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalService _globalService = GlobalService();
  SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc();

    _bloc.languageStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        // go to splash
        Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var langList = _globalService
            ?.getAppLandingData()
            ?.languageNavSelector
            ?.availableLanguages ??
        List.empty();

    var langDropdown = CustomDropdown<AvailableLanguages>(
      onChanged: (language) {
        var currentLanguageId = _globalService
                ?.getAppLandingData()
                ?.languageNavSelector
                ?.currentLanguageId ??
            -1;

        if (language.id != currentLanguageId) _bloc.changeLanguage(language.id);
        return;
      },
      preSelectedItem: langList.safeFirstWhere((language) {
        var currentLanguageId = _globalService
                ?.getAppLandingData()
                ?.languageNavSelector
                ?.currentLanguageId ??
            -1;

        return language.id == currentLanguageId;
      }),
      items: langList
              .map<DropdownMenuItem<AvailableLanguages>>((e) =>
                  DropdownMenuItem<AvailableLanguages>(
                      value: e, child: Text(e.name)))
              ?.toList() ??
          List.empty(),
    );

    var currencyList = _globalService
            ?.getAppLandingData()
            ?.currencyNavSelector
            ?.availableCurrencies ??
        List.empty();

    var currencyDropdown = CustomDropdown<AvailableCurrencies>(
      onChanged: (currency) {
        var currentCurrencyId = _globalService
                ?.getAppLandingData()
                ?.currencyNavSelector
                ?.currentCurrencyId ??
            -1;

        if (currency.id != currentCurrencyId) _bloc.changeCurrency(currency.id);
        return;
      },
      preSelectedItem: currencyList.safeFirstWhere((currency) {
        var currentCurrencyId = _globalService
                ?.getAppLandingData()
                ?.currencyNavSelector
                ?.currentCurrencyId ??
            -1;

        return currency.id == currentCurrencyId;
      }),
      items: currencyList
              .map<DropdownMenuItem<AvailableCurrencies>>((e) =>
                  DropdownMenuItem<AvailableCurrencies>(
                      value: e, child: Text(e.name)))
              ?.toList() ??
          List.empty(),
    );

    var titleStyle = Theme.of(context)
        .textTheme
        .subtitle2
        .copyWith(fontSize: 18, fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(_globalService.getString(Const.MORE_SETTINGS)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: defaultPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _globalService.getString(Const.SETTINGS_LANGUAGE),
                style: titleStyle,
              ),
              langDropdown,
              Text(
                _globalService.getString(Const.SETTINGS_CURRENCY),
                style: titleStyle,
              ),
              currencyDropdown,
              FutureBuilder<bool>(
                future: SessionData().isDarkTheme(),
                builder: (context, snapshot) {
                  bool darkTheme = snapshot.hasData ? snapshot.data : false;

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            _globalService.getString(Const.SETTINGS_THEME),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Spacer(),
                          Switch(
                            onChanged: (isEnabled) {
                              SessionData().setDarkTheme(isEnabled).then(
                                    (value) => setState(() {
                                      darkTheme = isEnabled;
                                      AppModel model = ScopedModel.of(context);
                                      model.seThemeMode(isEnabled);
                                    }),
                                  );
                            },
                            value: darkTheme,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveThumbColor: Colors.blueGrey,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
