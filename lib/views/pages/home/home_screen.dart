import 'package:flutter/material.dart';
import 'package:kixat/bloc/home_bloc.dart';
import 'package:kixat/views/customWidget/custom_fee.dart';
import 'package:kixat/views/customWidget/home/horizontal_categories.dart';
import 'package:kixat/views/customWidget/home/horizontal_manufacturer_slider.dart';
import 'package:kixat/views/customWidget/home/horizontal_product_box_slider.dart';
import 'package:kixat/views/customWidget/loading.dart';
import 'package:kixat/model/HomeSliderResponse.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/model/home/BestSellerProductResponse.dart';
import 'package:kixat/model/home/CategoriesWithProductsResponse.dart';
import 'package:kixat/model/home/FeaturedProductResponse.dart';
import 'package:kixat/model/home/ManufacturersResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/styles.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/views/customWidget/message_subscription.dart';
import 'package:kixat/views/pages/dialog_box.dart';

import '../../customWidget/cached_image.dart';
import 'home_carousel.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final List<CategoryTreeResponseData> categories;

  const HomeScreen({Key key, @required this.categories}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalService _globalService = GlobalService();
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
    if (_globalService.getAppLandingData().showHomepageSlider) {
      _bloc.fetchHomeBanners();
    }

    if (_globalService.getAppLandingData().showFeaturedProducts) {
      _bloc.getFeaturedProducts();
    }

    if (_globalService.getAppLandingData().showBestsellersOnHomepage) {
      _bloc.fetchBestSellerProducts();
    }

    if (_globalService.getAppLandingData().showHomepageCategoryProducts) {
      _bloc.fetchCategoriesWithProducts();
    }

    if (_globalService.getAppLandingData().showManufacturers) {
      _bloc.fetchManufacturers();
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: StreamBuilder<ApiResponse<HomeSliderResponse>>(
          stream: _bloc.sliderStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Loading(loadingMessage: snapshot.data.message),
                  );
                  break;
                case Status.COMPLETED:
                  return MainMenu(
                    sliderData: snapshot.data.data.data,
                    categories: widget.categories,
                  );
                  break;
                case Status.ERROR:
                  return SizedBox.shrink();
                  break;
              }
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key key, this.categories, this.sliderData}) : super(key: key);
  final List<CategoryTreeResponseData> categories;
  final HomeSliderData sliderData;

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          if (categories.isNotEmpty) SizedBox(height: 05),
          FeeCard(),
          SizedBox(height: 5),
          BannerSlider(sliderData),
          DashBoardMenu(categories: categories),
          SizedBox(height: 5),
          MessageSubsciptionCard(),
        ]);
  }
}

class SwitchButton extends StatefulWidget {
  SwitchButton(
      {Key key, this.title, this.subtitle, this.onChange, this.isSwitched})
      : super(key: key);

  final String title;
  final String subtitle;
  Function onChange;
  bool isSwitched;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 04),
      child: ListTile(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: Switch(
          value: widget.isSwitched,
          onChanged: (value) {
            setState(() {
              widget.isSwitched = value;
              if (value == true)
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogBoxScreen();
                    });
            });
          },
        ),
        subtitle: Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.labelLarge.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
