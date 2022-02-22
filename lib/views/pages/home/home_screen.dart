import 'package:flutter/material.dart';
import 'package:kixat/bloc/home_bloc.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slider banner
            StreamBuilder<ApiResponse<HomeSliderResponse>>(
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
                      return BannerSlider(snapshot.data.data.data);
                      break;
                    case Status.ERROR:
                      return SizedBox.shrink();
                      break;
                  }
                }
                return SizedBox.shrink();
              },
            ),

            // Our Categories
            if (widget.categories.isNotEmpty)
              HorizontalCategories(categories: widget.categories),
            SizedBox(height: 5),

            // BestSellers products
            StreamBuilder<ApiResponse<BestSellerProductResponse>>(
                stream: _bloc.bestSellerProdStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data.status == Status.COMPLETED) {
                    if (snapshot.data.data?.data?.isNotEmpty == true) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return HorizontalSlider(
                              '${_globalService.getString(Const.HOME_FEATURED_PRODUCT)}',
                              false,
                              false,
                              [],
                              snapshot.data.data.data);
                        },
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }
                  return SizedBox.shrink();
                }),

            // Featured products
            // StreamBuilder<ApiResponse<FeaturedProductResponse>>(
            //     stream: _bloc.featuredProdStream,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData &&
            //           snapshot.data.status == Status.COMPLETED) {
            //         if (snapshot.data.data?.data?.isNotEmpty == true) {
            //           return HorizontalSlider(
            //               '${_globalService.getString(Const.HOME_FEATURED_PRODUCT)}',
            //               false,
            //               false,
            //               [],
            //               snapshot.data.data.data);
            //         } else {
            //           return SizedBox.shrink();
            //         }
            //       }
            //       return SizedBox.shrink();
            //     }),

            // Categories with products
            // StreamBuilder<ApiResponse<CategoriesWithProductsResponse>>(
            //     stream: _bloc.categoriesWithProdStream,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData &&
            //           snapshot.data.status == Status.COMPLETED)
            //         return Column(
            //           children: [
            //             ...snapshot.data.data.data.map<Widget>((e) {
            //               return HorizontalSlider(
            //                 e.name,
            //                 true,
            //                 true,
            //                 e.subCategories,
            //                 e.products,
            //                 categoryId: e.id,
            //               );
            //             }).toList(),
            //           ],
            //         );
            //       return SizedBox.shrink();
            //     }),

            // Manufacturers slider
            // StreamBuilder<ApiResponse<ManufacturersResponse>>(
            // stream: _bloc.manufacturersStream,
            // builder: (context, snapshot) {
            //   if (snapshot.hasData &&
            //       snapshot.data.status == Status.COMPLETED) {
            //     if (snapshot.data.data?.data?.isNotEmpty == true) {
            //       return HorizontalManufacturerSlider(
            //           '${_globalService.getString(Const.HOME_MANUFACTURER)}',
            //           snapshot.data.data.data);
            //     } else {
            //       return SizedBox.shrink();
            //     }
            //   }
            //   return SizedBox.shrink();
            // }),
          ],
        ),
      ),
    );
  }
}

Widget dashboard = GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      // childAspectRatio: 3 / 2,
      crossAxisCount: 3,
      crossAxisSpacing: 06),
  itemBuilder: (context, index) {
    return Container(
        child: Card(
      child: Column(
        children: [
          Image.asset(
            "assets/bags.png",
            height: 80,
            width: 80,
          ),
          Text(
            "data",
            style: Styles.productNameTextStyle(context),
          ),
        ],
      ),
    ));
  },
);
