import 'package:flutter/material.dart';
import 'package:kixat/ScopedModelWrapper.dart';

import 'package:kixat/utils/styles.dart';
import 'package:kixat/views/pages/FcmHandler.dart';
import 'package:kixat/views/pages/account/address/add_edit_address_screen.dart';
import 'package:kixat/views/pages/account/address/address_list_screen.dart';
import 'package:kixat/views/pages/account/cart/shopping_cart_screen.dart';
import 'package:kixat/views/pages/account/change_password_screen.dart';
import 'package:kixat/views/pages/account/downloadableProduct/downloadable_product_screen.dart';
import 'package:kixat/views/pages/account/forgot_password_screen.dart';
import 'package:kixat/views/pages/account/login_screen.dart';
import 'package:kixat/views/pages/account/new_products_screen.dart';
import 'package:kixat/views/pages/account/order/order_details_screen.dart';
import 'package:kixat/views/pages/account/order/order_history_screen.dart';
import 'package:kixat/views/pages/account/returnRequest/ReturnRequestScreen.dart';
import 'package:kixat/views/pages/account/returnRequest/return_request_history_screen.dart';
import 'package:kixat/views/pages/account/review/customer_review_screen.dart';
import 'package:kixat/views/pages/account/review/product_review_screen.dart';
import 'package:kixat/views/pages/account/rewardPoint/reward_point_screen.dart';
import 'package:kixat/views/pages/account/subscription_screen.dart';
import 'package:kixat/views/pages/account/wishlist_screen.dart';
import 'package:kixat/views/pages/checkout/checkout_screen.dart';
import 'package:kixat/views/pages/checkout/checkout_webview.dart';
import 'package:kixat/views/pages/home/home_screen.dart';
import 'package:kixat/views/pages/more/barcode_scanner_screen.dart';
import 'package:kixat/views/pages/more/contact_us_screen.dart';
import 'package:kixat/views/pages/more/contact_vendor_screen.dart';
import 'package:kixat/views/pages/more/settings_screen.dart';
import 'package:kixat/views/pages/more/topic_screen.dart';
import 'package:kixat/views/pages/more/vendor_list_screen.dart';
import 'package:kixat/views/pages/product-list/product_list_screen.dart';
import 'package:kixat/views/pages/product/product_details_screen.dart';
import 'package:kixat/views/pages/product/zoomable_image_screen.dart';
import 'package:kixat/views/pages/splash.dart';
import 'package:kixat/views/pages/tabs-screen/error_screen.dart';
import 'package:kixat/views/pages/tabs-screen/tabs_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'views/pages/account/registration_sceen.dart';

void main() {
  runApp(ScopeModelWrapper());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KiXAT',
        theme: Styles.lightTheme(model),
        darkTheme: Styles.darkTheme(model),
        themeMode: model.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        builder: (context, child) {
          return Directionality(
            textDirection: model.appLandingData?.rtl == true
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child,
          );
        },
        routes: {
          '/': (context) => Splash(),
          TabsScreen.routeName: (context) => FcmHandler(child: TabsScreen()),
          HomeScreen.routeName: (context) => HomeScreen(categories: []),
          LoginScreen.routeName: (context) => LoginScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
          ShoppingCartScreen.routeName: (context) => ShoppingCartScreen(),
          CheckoutScreen.routeName: (context) => CheckoutScreen(),
          CheckoutWebView.routeName: (context) => CheckoutWebView(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          WishListScreen.routeName: (context) => WishListScreen(),
          OrderHistoryScreen.routeName: (context) => OrderHistoryScreen(),
          AddressListScreen.routeName: (context) => AddressListScreen(),
          RewardPointScreen.routeName: (context) => RewardPointScreen(),
          ContactUsScreen.routeName: (context) => ContactUsScreen(),
          BarcodeScannerScreen.routeName: (context) => BarcodeScannerScreen(),
          CustomerReviewScreen.routeName: (context) => CustomerReviewScreen(),
          DownloadableProductScreen.routeName: (context) =>
              DownloadableProductScreen(),
          VendorListScreen.routeName: (context) => VendorListScreen(),
          ReturnRequestHistoryScreen.routeName: (context) =>
              ReturnRequestHistoryScreen(),
          NewProductsScreen.routeName: (context) => NewProductsScreen(),
          SubscriptionScreen.routeName: (context) => SubscriptionScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == ProductDetailsPage.routeName) {
            final ProductDetailsScreenArguments args =
                settings.arguments as ProductDetailsScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailsPage(
                  productName: args.name,
                  productId: args.id,
                  productDetails: args.productDetails,
                );
              },
            );
          } else if (settings.name == ProductListScreen.routeName) {
            final ProductListScreenArguments args =
                settings.arguments as ProductListScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductListScreen(args.type, args.name, args.id);
              },
            );
          } else if (settings.name == ZoomableImageScreen.routeName) {
            final ZoomableImageScreenArguments args =
                settings.arguments as ZoomableImageScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ZoomableImageScreen(
                  pictureModel: args.pictureModel,
                  currentIndex: args.currentIndex,
                );
              },
            );
          } else if (settings.name == ProductReviewScreen.routeName) {
            final ProductReviewScreenArguments args =
                settings.arguments as ProductReviewScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ProductReviewScreen(
                  productId: args.id,
                );
              },
            );
          } else if (settings.name == OrderDetailsScreen.routeName) {
            final OrderDetailsScreenArguments args =
                settings.arguments as OrderDetailsScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return OrderDetailsScreen(
                  orderId: args.orderId,
                );
              },
            );
          } else if (settings.name == TopicScreen.routeName) {
            final TopicScreenArguments args =
                settings.arguments as TopicScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return TopicScreen(
                  screenArgument: args,
                );
              },
            );
          } else if (settings.name == RegistrationScreen.routeName) {
            final RegistrationScreenArguments args =
                settings.arguments as RegistrationScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return RegistrationScreen(
                  screenArgument: args,
                );
              },
            );
          } else if (settings.name == AddOrEditAddressScreen.routeName) {
            final AddOrEditAddressScreenArgs args =
                settings.arguments as AddOrEditAddressScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return AddOrEditAddressScreen(
                  args: args,
                );
              },
            );
          } else if (settings.name == ReturnRequestScreen.routeName) {
            final ReturnRequestScreenArgs args =
                settings.arguments as ReturnRequestScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return ReturnRequestScreen(
                  args: args,
                );
              },
            );
          } else if (settings.name == ContactVendorScreen.routeName) {
            final ContactVendorScreenArgs args =
                settings.arguments as ContactVendorScreenArgs;

            return MaterialPageRoute(
              builder: (context) {
                return ContactVendorScreen(
                  args: args,
                );
              },
            );
          } else if (settings.name == ErrorScreen.routeName) {
            final ErrorScreenArguments args =
                settings.arguments as ErrorScreenArguments;

            return MaterialPageRoute(
              builder: (context) {
                return ErrorScreen(
                  screenArgument: args,
                );
              },
            );
          }

          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      );
    });
  }
}
