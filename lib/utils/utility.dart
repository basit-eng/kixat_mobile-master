import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import 'package:kixat/model/AvailableOption.dart';
import 'package:kixat/model/GetBillingAddressResponse.dart';
import 'package:kixat/model/GetStatesResponse.dart';
import 'package:kixat/repository/BaseRepository.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/FileResponse.dart';
import 'package:kixat/utils/NotificationUtils.dart';
import 'package:kixat/utils/shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';

String generateRandomDeviceId() {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  return List.generate(15, (index) => _chars[r.nextInt(_chars.length)]).join();
}

Future<List<AvailableOption>> fetchStatesList(num countryId) async {
  GetStatesResponse response =
      await BaseRepository().getStatesByCountry(countryId);

  var stateList = response.data
          ?.map(
            (e) => AvailableOption(
              text: e.name,
              value: e.id.toString(),
            ),
          )
          ?.toList() ??
      [];

  // insert select
  stateList.insertAll(
    0,
    [
      AvailableOption(
        text: GlobalService().getString(Const.SELECT_STATE),
        value: '-1',
      ),
    ],
  );

  return stateList;
}

String getFormattedDate(DateTime date, {String format = 'MM/dd/yyyy'}) {
  try {
    return date != null ? DateFormat(format).format(date) : '';
  } catch (e) {
    return '';
  }
}

String getFormattedAddress(Address address) {
  GlobalService _globalService = GlobalService();
  if (address == null) return '';
  var formattedAddress = '';

  if (address.email != null)
    formattedAddress +=
        "${_globalService.getString(Const.EMAIL)}: ${address.email}\n";
  if (address.phoneNumber != null)
    formattedAddress +=
        "${_globalService.getString(Const.PHONE)}: ${address.phoneNumber}\n";
  if (address.company != null)
    formattedAddress +=
        "${_globalService.getString(Const.COMPANY)}: ${address.company}\n";
  if (address.address1 != null)
    formattedAddress +=
        "${_globalService.getString(Const.STREET_ADDRESS)}: ${address.address1}\n";
  if (address.address2 != null)
    formattedAddress +=
        "${_globalService.getString(Const.STREET_ADDRESS_2)}: ${address.address2}\n";
  if (address.zipPostalCode != null)
    formattedAddress +=
        "${_globalService.getString(Const.ZIP_CODE)}: ${address.zipPostalCode}\n";
  if (address.city != null)
    formattedAddress +=
        "${_globalService.getString(Const.CITY)}: ${address.city}\n";
  if (address.stateProvinceName != null)
    formattedAddress +=
        "${_globalService.getString(Const.STATE_PROVINCE)}: ${address.stateProvinceName}\n";
  if (address.countryName != null)
    formattedAddress +=
        "${_globalService.getString(Const.COUNTRY)}: ${address.countryName}";

  return formattedAddress.trimRight();
}

String stripHtmlTags(String htmlText) {
  final document = parse(htmlText);
  final String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}

/// Load AuthToken & DeviceId from storage to memory
///
/// This method loads previously stored AuthToken & DeviceId
/// from shared preference to Global variable.
///
/// If there is no stored DeviceId, it will be generated and stored
Future<void> prepareSessionData() async {
  GlobalService _globalService = GlobalService();

  _globalService.setAuthToken(await SessionData().getAuthToken());

  final deviceID = await SessionData().getDeviceId();
  if (deviceID.isEmpty) {
    var newDeviceId = generateRandomDeviceId();
    SessionData().setDeviceId(newDeviceId);
    _globalService.setDeviceId(newDeviceId);
  } else {
    _globalService.setDeviceId(deviceID);
  }
}

bool isDarkThemeEnabled(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

showSnackBar(BuildContext context, String message, bool isError) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red[600] : Colors.grey[800],
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    duration: Duration(milliseconds: 1500),
  ));
}

// hexSting format #FFFFFF
Color parseColor(String hexString) {
  try {
    return Color(int.parse(hexString.replaceFirst('#', '0x')) + 0xFF000000);
  } catch (e) {
    return Colors.orange;
  }
}

// hexSting format #FFFFFF
int parseColorInt(String hexString) {
  try {
    return int.parse(hexString.replaceFirst('#', '0x')) + 0xFF000000;
  } catch (e) {
    return 0xFF121212;
  }
}

Map<int, Color> getColorSwatch(Color color) {
  return {
    50: Color.fromRGBO(color.red, color.green, color.blue, .1),
    100: Color.fromRGBO(color.red, color.green, color.blue, .2),
    200: Color.fromRGBO(color.red, color.green, color.blue, .3),
    300: Color.fromRGBO(color.red, color.green, color.blue, .4),
    400: Color.fromRGBO(color.red, color.green, color.blue, .5),
    500: Color.fromRGBO(color.red, color.green, color.blue, .6),
    600: Color.fromRGBO(color.red, color.green, color.blue, .7),
    700: Color.fromRGBO(color.red, color.green, color.blue, .8),
    800: Color.fromRGBO(color.red, color.green, color.blue, .9),
    900: Color.fromRGBO(color.red, color.green, color.blue, 1),
  };
}

ButtonStyle roundButtonStyle(BuildContext context) {
  return ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}

Widget appbarGradient() {
  GlobalService _globalService = GlobalService();

  if (_globalService.getAppLandingData().gradientEnabled) {
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(_globalService),
      ),
    );
  } else {
    return Container(
      color:
          parseColor(_globalService.getAppLandingData().topBarBackgroundColor),
    );
  }
}

Divider getDivider() => Divider(color: Colors.grey[800]);

LinearGradient getGradient(GlobalService _globalService) => LinearGradient(
      colors: [
        parseColor(_globalService.getAppLandingData().gradientStartingColor),
        parseColor(_globalService.getAppLandingData().gradientMiddleColor),
        parseColor(_globalService.getAppLandingData().gradientEndingColor),
      ],
      stops: [0.30, 0.67, 1.0],
    );

EdgeInsets defaultPadding() => EdgeInsets.fromLTRB(12, 8, 12, 0);

void removeFocusFromInputField(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Map<String, Style> htmlNoPaddingStyle(
    {Map<String, Style> style, double fontSize}) {
  var styleMap = {
    "body": Style(
      fontSize: FontSize(fontSize ?? 16.0),
      // textAlign: TextAlign.justify,
      margin: EdgeInsets.all(0),
    ),
  };

  if (style != null) styleMap.addAll(style);

  return styleMap;
}

launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      // headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  }
}

Future<File> saveFileToDisk(FileResponse response,
    {bool showNotification = false}) async {
  String path = '';

  if (Platform.isAndroid) {
    path = "/storage/emulated/0/Download";
  } else if (Platform.isIOS) {
    path = (await getApplicationDocumentsDirectory()).path;
  } else {
    throw Exception('Platform not supported yet');
  }

  if (!await Directory(path).exists()) await Directory(path).create();
  File file = await File('$path/${response.filename}').writeAsBytes(response.fileBytes);

  if (showNotification) {
    NotificationUtils().showFileDownloadNotification(path: file.path);
  }

  return file;
}

Widget sectionTitleWithDivider(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Divider(color: Colors.grey[800])
      ],
    ),
  );
}
