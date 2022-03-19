import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/views/customWidget/cached_image.dart';
import 'package:schoolapp/views/customWidget/dot_indicator.dart';
import 'package:schoolapp/model/HomeSliderResponse.dart';
import 'package:schoolapp/views/pages/more/topic_screen.dart';
import 'package:schoolapp/views/pages/product-list/product_list_screen.dart';
import 'package:schoolapp/views/pages/product/product_details_screen.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/GetBy.dart';
import 'package:schoolapp/utils/SliderType.dart';

class BannerSlider extends StatefulWidget {
  final HomeSliderData sliderData;

  const BannerSlider(this.sliderData, {Key key}) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState(this.sliderData);
}

class _BannerSliderState extends State<BannerSlider> {
  final HomeSliderData sliderData;
  final GlobalService _globalService = GlobalService();
  int _carouselIndex = 0;

  _BannerSliderState(this.sliderData);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 3.5 / 1, // TODO make aspectRatio dynamic
            viewportFraction: 1,
            enableInfiniteScroll: true,
            autoPlay: _globalService.getAppLandingData().sliderAutoPlay,
            autoPlayInterval: Duration(
              seconds:
                  _globalService.getAppLandingData().sliderAutoPlayTimeout !=
                          null
                      ? _globalService.getAppLandingData().sliderAutoPlayTimeout
                      : 3,
            ),
            onPageChanged: (index, reason) {
              setState(() {
                _carouselIndex = index;
              });
            },
          ),
          items: sliderData.sliders.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => onSliderImageClick(i),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Image border
                    child: SizedBox(
                      // size: Size.fromRadius(48), // Image radius
                      width: size.width - 30,
                      height: 50,
                      // height: size.height * 0.01,
                      child: CpImage(
                        url: i.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned.fill(
          bottom: 3,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DotIndicator(
              dotsCount: sliderData?.sliders?.length ?? 0,
              selectedIndex: _carouselIndex,
            ),
          ),
        ),
      ],
    );
  }

  onSliderImageClick(Sliders i) {
    switch (i.sliderType) {
      case SliderType.CATEGORY:
        {
          Navigator.of(context).pushNamed(ProductListScreen.routeName,
              arguments: ProductListScreenArguments(
                id: i.entityId,
                name: '',
                type: GetBy.CATEGORY,
              ));
        }
        break;
      case SliderType.MANUFACTURER:
        {
          Navigator.of(context).pushNamed(ProductListScreen.routeName,
              arguments: ProductListScreenArguments(
                id: i.entityId,
                name: '',
                type: GetBy.MANUFACTURER,
              ));
        }
        break;
      case SliderType.VENDOR:
        {
          Navigator.of(context).pushNamed(ProductListScreen.routeName,
              arguments: ProductListScreenArguments(
                id: i.entityId,
                name: '',
                type: GetBy.VENDOR,
              ));
        }
        break;
      case SliderType.PRODUCT:
        {
          Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
              arguments: ProductDetailsScreenArguments(
                id: i.entityId,
                name: '',
              ));
        }
        break;
      case SliderType.TOPIC:
        {
          Navigator.of(context).pushNamed(TopicScreen.routeName,
              arguments: TopicScreenArguments(topicId: i.entityId));
        }
        break;
    }
  }
}
