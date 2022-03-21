import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:softify/bloc/product_box_bloc.dart';
import 'package:softify/model/ProductSummary.dart';
import 'package:softify/networking/ApiResponse.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/AppConstants.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/utility.dart';
import 'package:softify/views/customWidget/cached_image.dart';
import 'package:softify/views/customWidget/loading_dialog.dart';
import 'package:softify/views/pages/product/product_details_screen.dart';

class HorizontalProductBox extends StatelessWidget {
  final ProductSummary productData;
  final String _new = GlobalService().getString(Const.RIBBON_NEW);

  HorizontalProductBox(this.productData);

  void addToCartOrWishList(BuildContext context, bool isCart) async {
    DialogBuilder(context).showLoader();
    var response = await ProductBoxBloc().addToCart(productData.id, isCart);
    DialogBuilder(context).hideLoader();

    if (response.status == Status.COMPLETED) {
      GlobalService()
          .updateCartCount(response.data?.data?.totalShoppingCartProducts ?? 0);
      GlobalService()
          .updateWishListCount(response.data?.data?.totalWishListProducts ?? 0);

      if (response?.data?.data?.redirectToDetailsPage == true) {
        Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: productData.id,
              name: productData.name,
            ));
      } else {
        showSnackBar(
          context,
          isCart
              ? GlobalService().getString(Const.PRODUCT_ADDED_TO_CART)
              : GlobalService().getString(Const.PRODUCT_ADDED_TO_WISHLIST),
          false,
        );
      }
    } else if (response.status == Status.ERROR) {
      if (response.message.isNotEmpty)
        showSnackBar(context, response.message, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _thumbnail = Container(
      padding: EdgeInsets.all(12),
      alignment: Alignment.center,
      height: AppConstants.productBoxThumbnailSize,
      width: MediaQuery.of(context).size.width * 0.80,
      color: Colors.white,
      child: CpImage(
        url: productData.defaultPictureModel.imageUrl,
        fit: BoxFit.cover,
        // height: AppConstants.productBoxThumbnailSize,
      ),
    );

    final imageBox = ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: productData.markAsNew == true
          ? Banner(
              message: _new,
              location: GlobalService().getAppLandingData().rtl
                  ? BannerLocation.topStart
                  : BannerLocation.topEnd,
              color: Colors.green,
              child: _thumbnail,
            )
          : _thumbnail,
    );

    final btnWishlist = GestureDetector(
      onTap: () {
        addToCartOrWishList(context, false);
      },
      child: Container(
        width: 20,
        height: 20,
        child: Icon(
          Icons.favorite_border,
          color: Color(0xFFFF476E),
          size: 26,
        ),
      ),
    );

    final btnCart = GestureDetector(
      onTap: () {
        addToCartOrWishList(context, true);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              width: .2,
            )),
        child: Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
    );

    final productName = Text(
      '${productData.name}\n',
      style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
      strutStyle: StrutStyle(
        fontSize: 16.0,
        height: 1.3,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.center,
    );

    final ratingBar = RatingBar.builder(
      ignoreGestures: true,
      itemSize: 12,
      initialRating:
          productData?.reviewOverviewModel?.ratingSum?.toDouble() ?? 0,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (_) {},
    );

    return Container(
      width: AppConstants.productBoxThumbnailSize,
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () => Navigator.pushNamed(
            context,
            ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: productData.id,
              name: productData.name,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  imageBox,
                  if (productData?.productPrice?.disableWishlistButton == false)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: btnWishlist,
                    ),
                  if (productData?.productPrice?.disableBuyButton == false)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: btnCart,
                    )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: productName,
              ),
              ratingBar,
              Padding(
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (productData.productPrice.price != null)
                      Container(
                        child: Text(
                          productData.productPrice.price ?? '0',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontFamily: 'LatoBold'),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (productData.productPrice.oldPrice != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            productData.productPrice.oldPrice,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontFamily: 'LatoBold',
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
