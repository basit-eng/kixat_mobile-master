import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:softify/views/customWidget/CustomAppBar.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/utils/CheckoutConstants.dart';

class CheckoutWebView extends StatefulWidget {
  static const routeName = '/checkoutWebView';

  @override
  _CheckoutWebViewState createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  CookieManager cookieManager = CookieManager.instance();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          javaScriptCanOpenWindowsAutomatically: true,
          javaScriptEnabled: true,
          userAgent:
              "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        thirdPartyCookiesEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true, sharedCookiesEnabled: true));

  Future<void> clearCookie() async {
    await cookieManager.deleteAllCookies();
    return;
  }

  @override
  Widget build(BuildContext context) {
    CheckoutWebViewScreenData args = ModalRoute.of(context).settings.arguments;
    var url = args.action == CheckoutConstants.PaymentInfo
        ? Endpoints.paymentInfoUrl
        : Endpoints.redirectUrl;

    // add order id in case of repost payment
    if (args.action == CheckoutConstants.RetryPayment)
      url = '$url&orderId=${args.orderId}';

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(args.screenTitle ?? ''),
      ),
      body: FutureBuilder(
        future: clearCookie(),
        builder: (context, snapshot) {
          return InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(url),
              headers: ApiBaseHelper().getRequestHeader(),
            ),
            initialOptions: options,
            onWebViewCreated: (controller) async {
              await controller.setOptions(options: options);
            },

            /*shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.headers;
              print(uri.toString());

              // return NavigationActionPolicy.CANCEL;

              return NavigationActionPolicy.ALLOW;
            },*/

            onLoadStop: (controller, mUrl) async {
              final url = mUrl.toString();
              if (url.contains("/step/")) {
                var nextStep = url[url.length - 1];
                Navigator.pop(context, nextStep);
              } else if (url.contains("/completed/")) {
                // || url.contains("/orderdetails")
                int orderId = -1;

                try {
                  orderId = int.parse(url.split('/').last);
                } catch (e) {
                  orderId = -1;
                }

                Navigator.pop(context, orderId);
              }
            },
          );
        },
      ),
    );
  }
}

class CheckoutWebViewScreenData {
  int action;
  String screenTitle;
  int orderId;

  CheckoutWebViewScreenData(
      {@required this.action, @required this.screenTitle, this.orderId});
}
