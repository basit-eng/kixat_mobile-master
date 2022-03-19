import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:schoolapp/bloc/product_box_bloc.dart';
import 'package:schoolapp/model/ProductSummary.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/AppConstants.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/utility.dart';
import 'package:schoolapp/views/customWidget/cached_image.dart';
import 'package:schoolapp/views/customWidget/loading_dialog.dart';
import 'package:schoolapp/views/pages/product/product_details_screen.dart';

class ProductBox extends StatelessWidget {
  final ProductSummary productData;
  final String _new = GlobalService().getString(Const.RIBBON_NEW);

  ProductBox(this.productData);

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
    /*var thumbnail = productData.markAsNew
        ? Banner(
            message: _new,
            location: BannerLocation.topEnd,
            color: Colors.green,
            child: CpImage(
              url: productData.defaultPictureModel.imageUrl,
              fit: BoxFit.cover,
            ),
          )
        : CpImage(
            url: productData.defaultPictureModel.imageUrl,
            fit: BoxFit.cover,
          );*/

    final _thumbnail = Container(
      height: AppConstants.productBoxThumbnailSize,
      width: double.maxFinite,
      color: Colors.grey[100],
      child: CpImage(
        url: productData.defaultPictureModel.imageUrl,
        fit: BoxFit.cover,
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
        height: 1.2,
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
      width: 175,
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
            children: <Widget>[
              Stack(
                children: <Widget>[
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
                    ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: productName,
                  ),
                  ratingBar,
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (productData.productPrice.price != null)
                              Text(
                                productData.productPrice.price,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontFamily: 'LatoBold'),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            if (productData.productPrice.oldPrice != null)
                              Padding(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
