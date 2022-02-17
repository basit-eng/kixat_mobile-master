import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:kixat/bloc/product_details_bloc.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:kixat/views/customWidget/CustomButton.dart';
import 'package:kixat/views/customWidget/CustomDropdown.dart';
import 'package:kixat/views/customWidget/RoundButton.dart';
import 'package:kixat/views/customWidget/SpecificationAttributeItem.dart';
import 'package:kixat/views/customWidget/cached_image.dart';
import 'package:kixat/views/customWidget/dot_indicator.dart';
import 'package:kixat/views/customWidget/error.dart';
import 'package:kixat/views/customWidget/estimate_shipping.dart';
import 'package:kixat/views/customWidget/home/horizontal_product_box_slider.dart';
import 'package:kixat/views/customWidget/loading.dart';
import 'package:kixat/views/customWidget/loading_dialog.dart';
import 'package:kixat/model/AvailableOption.dart';
import 'package:kixat/model/ProductDetailsResponse.dart';
import 'package:kixat/model/ProductSummary.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/views/pages/account/cart/shopping_cart_screen.dart';
import 'package:kixat/views/pages/account/review/product_review_screen.dart';
import 'package:kixat/views/pages/app_bar_cart.dart';
import 'package:kixat/views/pages/product-list/product_list_screen.dart';
import 'package:kixat/views/pages/product/item_group_product.dart';
import 'package:kixat/views/pages/product/zoomable_image_screen.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/AppConstants.dart';
import 'package:kixat/utils/ButtonShape.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/CustomAttributeManager.dart';
import 'package:kixat/utils/GetBy.dart';
import 'package:kixat/utils/ValidationMixin.dart';
import 'package:kixat/utils/extensions.dart';
import 'package:kixat/utils/shared_pref.dart';
import 'package:kixat/utils/styles.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/utils/readmore.dart';
import 'package:permission_handler/permission_handler.dart';

class ProductDetailsPage extends StatefulWidget {
  static const routeName = '/productDetails';
  final String productName;
  final num productId;
  final ProductDetails productDetails;

  ProductDetailsPage(
      {Key key, this.productId, this.productName, this.productDetails})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState(
        productId: productId,
        productName: productName,
        productDetails: this.productDetails,
      );
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with ValidationMixin {
  GlobalService _globalService = GlobalService();
  ProductDetailsBloc _bloc;
  ProductDetailsScreenArguments args;
  CustomAttributeManager attributeManager;
  int _carouselIndex = 0;

  final _giftCardFormKey = GlobalKey<FormState>();
  final _rentalFormKey = GlobalKey<FormState>();

  final String productName;
  final num productId;
  final ProductDetails productDetails;

  _ProductDetailsPageState(
      {this.productId, this.productName, this.productDetails});

  @override
  void initState() {
    super.initState();

    _bloc = ProductDetailsBloc();

    if (this.productDetails == null) {
      _bloc.fetchProductDetails(productId);
    } else {
      _bloc.setAssociatedProduct(this.productDetails);
    }

    _bloc.fetchRelatedProducts(productId);
    _bloc.fetchCrossSellProducts(productId);

    _bloc.addToCartStream.listen((event) {
      if (event.status == Status.ERROR) {
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.COMPLETED) {
        showSnackBar(context, event.data?.message ?? '', false);

        setState(() {
          _globalService.updateCartCount(
              event.data?.data?.totalShoppingCartProducts ?? 0);
          _globalService.updateWishListCount(
              event.data?.data?.totalWishListProducts ?? 0);
        });
      }
    });

    _bloc.loaderStream.listen((showLoader) {
      if (showLoader == true) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.redirectToCartStream.listen((redirect) {
      if (redirect)
        Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
    });

    _bloc.fileUploadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        attributeManager?.addUploadedFileGuid(
            event.data.attributedId, event.data.downloadGuid);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.sampleDownloadStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if (event.data.file != null) {
          showSnackBar(
              context, _globalService.getString(Const.FILE_DOWNLOADED), false);
        } else if (event.data.jsonResponse.data.downloadUrl != null) {
          launchUrl(event.data.jsonResponse.data.downloadUrl);
        }
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.subStatusStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        showSubscriptionPopup(
            event.data.alreadySubscribed, event.data.productId);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.changeStatusStream.listen((event) {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.data, false);
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        // updating UI to show selected attribute values
        setState(() {
          if (priceAdjNeeded) {
            _bloc.postSelectedAttributes(
              productId,
              attributeManager
                  .getSelectedAttributes(AppConstants.productAttributePrefix),
            );
          }
        });
      },
      onFileSelected: (file, attributeId) {
        _bloc.uploadFile(file.path, attributeId);
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StreamBuilder<String>(
          initialData: productName,
          stream: _bloc.titleStream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Text(snapshot.data);
            else
              return Text(productName);
          },
        ),
        actions: [
          AppBarCart(),
        ],
      ),
      body: StreamBuilder<ApiResponse<ProductDetails>>(
        stream: _bloc.prodDetailsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return getProductDetailsWidget(snapshot.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchProductDetails(productId),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget getProductDetailsWidget(ProductDetails data) {
    var divider = Divider(color: Colors.grey[600]);
    var titleStyle = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(fontSize: 18, fontWeight: FontWeight.bold);

    var productCarousel = Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _carouselIndex = index;
              });
            },
          ),
          items: data.pictureModels.map((model) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      ZoomableImageScreen.routeName,
                      arguments: ZoomableImageScreenArguments(
                        pictureModel: data.pictureModels,
                        currentIndex: data.pictureModels.indexOf(model),
                      ),
                    ),
                    child: CpImage(
                      url: model.fullSizeImageUrl,
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
              dotsCount: data?.pictureModels?.length ?? 0,
              selectedIndex: _carouselIndex,
            ),
          ),
        ),
        if (!data.addToCart.disableWishlistButton)
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () => _addToCartClick(data,
                  cartType: AppConstants.typeWishList, redirectToCart: false),
              child: Icon(
                Icons.favorite_border,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
              backgroundColor: Colors.white70,
            ),
          ),
      ],
    );

    var productName = Text(
      data.name,
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
    );

    //var shortDescription = Html(
    //  data: data.shortDescription ?? '',
    //  style: htmlNoPaddingStyle(),
    //);
    var shortDescription = ReadMoreText(
      data.shortDescription ?? '',
      trimLines: 3,
      colorClickableText: Colors.pink,
      trimMode: TrimMode.Line,
      trimCollapsedText: '...show more',
      trimExpandedText: ' show less',
    );
    var fullDescription = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divider,
          Text(_globalService.getString(Const.PRODUCT_DESCRIPTION),
              style: titleStyle),
          SizedBox(height: 10),
          Html(
            data: data.fullDescription ?? '',
            style: htmlNoPaddingStyle(),
          ),
          divider,
        ],
      ),
    );

    // Product price section
    var manualPriceEntry = TextFormField(
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _globalService.getString(Const.IS_REQUIRED);
        }
        return null;
      },
      onChanged: (value) =>
          data.addToCart.customerEnteredPrice = num.tryParse(value) ?? 0,
      initialValue: data.addToCart.customerEnteredPrice.toString() ?? '0',
      textInputAction: TextInputAction.done,
      decoration:
          inputDecor(data.addToCart.customerEnteredPriceRange ?? '', true),
    );

    var availability = Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((data.stockAvailability ?? '').isNotEmpty)
            Row(
              children: [
                Text(_globalService.getString(Const.PRODUCT_AVAILABILITY),
                    style: titleStyle),
                SizedBox(width: 10),
                Text(
                  data.stockAvailability,
                  style: titleStyle.copyWith(
                      color: Theme.of(context).primaryColor),
                )
              ],
            ),
          if (data.isFreeShipping) SizedBox(height: 5),
          if (data.isFreeShipping)
            Row(
              children: [
                Icon(Icons.local_shipping_sharp),
                SizedBox(width: 10),
                Text(_globalService.getString(Const.PRODUCT_FREE_SHIPPING)),
              ],
            ),
          if (data.deliveryDate != null &&
              data.deliveryDate?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Text(
                      '${_globalService.getString(Const.PRODUCT_DELIVERY_DATE)}',
                      style: titleStyle),
                  SizedBox(width: 10),
                  Text(data.deliveryDate),
                ],
              ),
            ),
          // back in stock subscription button
          if (data.displayBackInStockSubscription == true)
            OutlinedButton(
                onPressed: () {
                  SessionData().isLoggedIn().then((loggedIn) {
                    if (loggedIn) {
                      _bloc.getSubscriptionStatus(data.id);
                    } else {
                      showSnackBar(
                          context,
                          _globalService
                              .getString(Const.BACK_IN_STOCK_ONLY_REGISTERED),
                          true);
                    }
                  });
                },
                child: Text(_globalService
                    .getString(Const.BACK_IN_STOCK_NOTIFY_ME_WHEN_AVAILABLE))),
        ],
      ),
    );

    var allowedQuantityDropdown = CustomDropdown<AvailableOption>(
      onChanged: (value) {
        setState(() {
          _bloc.selectedQuantity = value;
        });
      },
      preSelectedItem: _bloc.selectedQuantity,
      items: data.addToCart?.allowedQuantities
              ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                  DropdownMenuItem<AvailableOption>(
                      value: e, child: Text(e.text)))
              ?.toList() ??
          List.empty(),
    );

    var quantityBox = Row(
      children: [
        Flexible(
          flex: 6,
          child: Text(_globalService.getString(Const.PRODUCT_QUANTITY),
              style: titleStyle),
        ),
        SizedBox(width: 10),
        Flexible(
          flex: 12,
          child: SizedBox(
            height: 42,
            child: TextField(
              readOnly: true,
              keyboardType: TextInputType.number,
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  data.addToCart.enteredQuantity = int.parse(value);
                });
              },
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      24), // border color Color(0xFFD4D3DA)
                ),
                contentPadding: EdgeInsets.zero,
                hintText: (data.addToCart.enteredQuantity ?? 1).toString(),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          flex: 3,
          child: RoundButton(
            onClick: () {
              setState(() {
                if (data.addToCart.enteredQuantity <= 1) {
                  showSnackBar(
                      context,
                      _globalService.getString(Const.PRODUCT_QUANTITY_POSITIVE),
                      true);
                } else {
                  data.addToCart.enteredQuantity--;
                }
              });
            },
            radius: 45,
            icon: Icon(
              Icons.remove,
              size: 18.0,
            ),
          ),
        ),
        SizedBox(width: 5),
        Flexible(
          flex: 3,
          child: RoundButton(
            onClick: () {
              setState(() {
                data.addToCart.enteredQuantity++;
              });
            },
            radius: 45,
            icon: Icon(
              Icons.add,
              size: 18.0,
            ),
          ),
        ),
      ],
    );

    var ratingAndReview = InkWell(
      onTap: () {
        if (data?.productReviewOverview?.allowCustomerReviews == true) {
          Navigator.of(context).pushNamed(
            ProductReviewScreen.routeName,
            arguments: ProductReviewScreenArguments(id: data.id),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: RatingBar.builder(
              ignoreGestures: true,
              itemSize: 15,
              initialRating: data.productReviewOverview.ratingSum.toDouble(),
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_) {},
            ),
          ),
          SizedBox(width: 10),
          Text(
              '${data.productReviewOverview.totalReviews} ${_globalService.getString(Const.TITLE_REVIEW)}'),
        ],
      ),
    );

    var btnSampleDownload = data.hasSampleDownload
        ? OutlinedButton.icon(
            icon: Icon(Icons.download_sharp),
            label:
                Text(_globalService.getString(Const.PRODUCT_SAMPLE_DOWNLOAD)),
            onPressed: () async {
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request().then((value) => {
                      if (value.isGranted) {_bloc.downloadSample(productId)}
                    });
              } else {
                _bloc.downloadSample(productId);
              }
            },
          )
        : SizedBox.shrink();

    var productTags = Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.PRODUCT_TAG), style: titleStyle),
          SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.productTags.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                        ProductListScreen.routeName,
                        arguments: ProductListScreenArguments(
                            name: data.productTags[index].name,
                            id: data.productTags[index].id,
                            type: GetBy.TAG)),
                    child: Chip(
                      label: Text(data.productTags[index].name +
                          ' (${data.productTags[index].productCount})'),
                      padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                      elevation: 1,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    var productManufacturers = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.PRODUCT_MANUFACTURER),
              style: titleStyle),
          SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.productManufacturers.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                        ProductListScreen.routeName,
                        arguments: ProductListScreenArguments(
                            name: data.productManufacturers[index].name,
                            id: data.productManufacturers[index].id,
                            type: GetBy.MANUFACTURER)),
                    child: Chip(
                      label: Text(data.productManufacturers[index].name),
                      padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                      elevation: 1,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    var productVendorW = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.PRODUCT_VENDOR),
              style: titleStyle),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                  ProductListScreen.routeName,
                  arguments: ProductListScreenArguments(
                      name: data.vendorModel.name,
                      id: data.vendorModel.id,
                      type: GetBy.VENDOR)),
              child: Chip(
                label: Text(data.vendorModel.name ?? ""),
                padding: EdgeInsets.fromLTRB(3, 0, 3, 3),
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );

    CustomButton btnAddToCart = CustomButton(
      label: data.addToCart?.availableForPreOrder == true
          ? _globalService.getString(Const.CART_PRE_ORDER).toUpperCase()
          : _globalService.getString(Const.PRODUCT_BTN_ADDTOCART).toUpperCase(),
      shape: data.addToCart?.availableForPreOrder == true
          ? ButtonShape.RoundedTop
          : _globalService.getAppLandingData().rtl
              ? ButtonShape.RoundedTopRight
              : ButtonShape.RoundedTopLeft,
      onClick: () => _addToCartClick(data, cartType: 1, redirectToCart: false),
      backgroundColor: Styles.secondaryButtonColor,
    );

    CustomButton btnBuyNow = CustomButton(
      label: data.addToCart?.isRental == true
          ? _globalService.getString(Const.PRODUCT_BTN_RENT_NOW).toUpperCase()
          : _globalService.getString(Const.PRODUCT_BTN_BUY_NOW).toUpperCase(),
      shape: _globalService.getAppLandingData().rtl
          ? ButtonShape.RoundedTopLeft
          : ButtonShape.RoundedTopRight,
      onClick: () => _addToCartClick(data, cartType: 1, redirectToCart: true),
    );

    var productSku = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.SKU), style: titleStyle),
          SizedBox(width: 10),
          Text(data.sku ?? ''),
        ],
      ),
    );

    var productManufacturerPartNumber = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${_globalService.getString(Const.PRODUCT_MANUFACTURER_PART_NUM)}',
              style: titleStyle),
          SizedBox(height: 10),
          Text(data.manufacturerPartNumber ?? ''),
        ],
      ),
    );

    var productGtin = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_globalService.getString(Const.SKU)}', style: titleStyle),
          SizedBox(height: 10),
          Text(data.gtin ?? ''),
        ],
      ),
    );

    var giftCartSection = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.GIFT_CARD), style: titleStyle),
          SizedBox(height: 10),
          Form(
            key: _giftCardFormKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService
                          .getString(Const.PRODUCT_GIFT_CARD_SENDER);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.senderName = value,
                  initialValue: data.giftCard.senderName,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_SENDER, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService
                          .getString(Const.PRODUCT_GIFT_CARD_SENDER_EMAIL);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.senderEmail = value,
                  initialValue: data.giftCard.senderEmail,
                  textInputAction: TextInputAction.next,
                  decoration:
                      inputDecor(Const.PRODUCT_GIFT_CARD_SENDER_EMAIL, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService
                          .getString(Const.PRODUCT_GIFT_CARD_RECIPIENT);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.recipientName = value,
                  initialValue: data.giftCard.recipientName,
                  textInputAction: TextInputAction.next,
                  decoration:
                      inputDecor(Const.PRODUCT_GIFT_CARD_RECIPIENT, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService
                          .getString(Const.PRODUCT_GIFT_CARD_RECIPIENT_EMAIL);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.recipientEmail = value,
                  initialValue: data.giftCard.recipientEmail,
                  textInputAction: TextInputAction.next,
                  decoration:
                      inputDecor(Const.PRODUCT_GIFT_CARD_RECIPIENT_EMAIL, true),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 1,
                  autofocus: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _globalService
                          .getString(Const.PRODUCT_GIFT_CARD_MESSAGE);
                    }
                    return null;
                  },
                  onChanged: (value) => data.giftCard.message = value,
                  initialValue: data.giftCard.message,
                  textInputAction: TextInputAction.newline,
                  decoration: inputDecor(Const.PRODUCT_GIFT_CARD_MESSAGE, true),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Rental start & end date
    // TODO form validation for rental product
    var rentalSection = Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_globalService.getString(Const.PRODUCT_RENT), style: titleStyle),
          Form(
              key: _rentalFormKey,
              child: Column(
                children: [
                  TextFormField(
                    key: UniqueKey(),
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    readOnly: true,
                    initialValue: _bloc.rentalStartDate != null
                        ? DateFormat('MM/dd/yyyy').format(_bloc.rentalStartDate)
                        : '',
                    validator: (value) {
                      if (data?.isRental == true &&
                          (value == null || value.isEmpty)) {
                        return _globalService.getString(Const.IS_REQUIRED);
                      }
                      return null;
                    },
                    onTap: () => _selectDate(true),
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(Const.PRODUCT_RENTAL_START, true),
                  ),
                  TextFormField(
                    key: UniqueKey(),
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    readOnly: true,
                    initialValue: _bloc.rentalEndDate != null
                        ? DateFormat('MM/dd/yyyy').format(_bloc.rentalEndDate)
                        : '',
                    validator: (value) {
                      if (data?.isRental == true &&
                          (value == null || value.isEmpty)) {
                        return _globalService.getString(Const.IS_REQUIRED);
                      }
                      return null;
                    },
                    onTap: () => _selectDate(false),
                    textInputAction: TextInputAction.done,
                    decoration: inputDecor(Const.PRODUCT_RENTAL_END, true),
                  )
                ],
              )),
          SizedBox(height: 10),
        ],
      ),
    );

    // Estimate shipping
    var btnEstimateShipping = OutlinedButton(
      onPressed: () {
        var formValues = attributeManager
            .getSelectedAttributes(AppConstants.productAttributePrefix);
        formValues.addAll(_bloc.getProductFormValues(data));

        showDialog(
          context: context,
          builder: (_) => EstimateShippingDialog(
            data.productEstimateShipping,
            true,
            formValues: formValues,
          ),
        );
      },
      child: Text(_globalService.getString(Const.CART_ESTIMATE_SHIPPING_BTN)),
    );

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              productCarousel,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    productName,
                    SizedBox(height: 10),
                    shortDescription,
                    SizedBox(height: 10),
                    if (!data.productPrice.hidePrices &&
                        !data.addToCart.customerEntersPrice &&
                        data.productType != 10) // if not group product
                      getProductPrice(data.productPrice, 20),
                    if (data.addToCart.customerEntersPrice) manualPriceEntry,
                    if (data.tierPrices?.isNotEmpty == true)
                      getTierPriceTable(data.tierPrices),
                    availability,
                    attributeManager
                        .populateCustomAttributes(data.productAttributes),
                    ratingAndReview,
                    if (data.productEstimateShipping?.enabled == true)
                      btnEstimateShipping,
                    btnSampleDownload,
                    divider,
                    if (data.addToCart.allowedQuantities?.isNotEmpty == false &&
                        data.productType != 10 &&
                        (data.displayBackInStockSubscription ?? false) == false)
                      quantityBox,
                    if (data.addToCart.allowedQuantities?.isNotEmpty ==
                        true) ...[
                      Text(
                        _globalService.getString(Const.PRODUCT_QUANTITY),
                        style: titleStyle,
                      ),
                      allowedQuantityDropdown,
                    ],
                    if (data.showSku && data.sku?.isNotEmpty == true)
                      productSku,
                    if (data.showManufacturerPartNumber)
                      productManufacturerPartNumber,
                    if (data.showGtin) productGtin,
                    if (data.productSpecificationModel?.groups
                            ?.safeFirst()
                            ?.attributes
                            ?.isNotEmpty ==
                        true)
                      populateSpecificationAttributes(
                          data.productSpecificationModel?.groups),
                    if (data.fullDescription?.isNotEmpty == true)
                      fullDescription,
                    if (data.productType == 10 &&
                        data.associatedProducts?.isNotEmpty == true) ...[
                      Text(
                        _globalService.getString(Const.PRODUCT_GROUPED_PRODUCT),
                        style: titleStyle,
                      ),
                      SizedBox(height: 5),
                      populateAssociatedProducts(data.associatedProducts),
                    ],
                    if (data.productTags.isNotEmpty) productTags,
                    if (data.productManufacturers.isNotEmpty)
                      productManufacturers,
                    if (data.vendorModel != null && data.showVendor)
                      productVendorW,
                    if (data.giftCard?.isGiftCard == true) giftCartSection,
                    if (data.isRental == true) rentalSection,
                  ],
                ),
              ),
              StreamBuilder<ApiResponse<List<ProductSummary>>>(
                stream: _bloc.relatedProductStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data.status == Status.COMPLETED &&
                      snapshot.data.data?.isNotEmpty == true) {
                    return HorizontalSlider(
                        _globalService.getString(Const.PRODUCT_RELATED_PRODUCT),
                        false,
                        false,
                        [],
                        snapshot.data.data);
                  }
                  return SizedBox.shrink();
                },
              ),
              StreamBuilder<ApiResponse<List<ProductSummary>>>(
                stream: _bloc.crossSellStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data.status == Status.COMPLETED &&
                      snapshot.data.data?.isNotEmpty == true) {
                    return HorizontalSlider(
                        _globalService.getString(Const.PRODUCT_ALSO_PURCHASED),
                        false,
                        false,
                        [],
                        snapshot.data.data);
                  }
                  return SizedBox.shrink();
                },
              ),
              if (!data.addToCart.disableBuyButton && data.productType != 10)
                SizedBox(height: 60), // margin for button
            ],
          ),
        ),
        if (!data.addToCart.disableBuyButton && data.productType != 10)
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: btnAddToCart),
                if (data.addToCart?.availableForPreOrder == false)
                  Expanded(child: btnBuyNow),
              ],
            ),
          )
      ],
    );
  }

  Future<void> _selectDate(bool isRentalStart) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: isRentalStart
          ? DateTime.now()
          : (_bloc.rentalStartDate ?? DateTime.now()),
      firstDate: isRentalStart
          ? DateTime.now()
          : (_bloc.rentalStartDate ?? DateTime.now()),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        if (isRentalStart)
          _bloc.rentalStartDate = pickedDate;
        else
          _bloc.rentalEndDate = pickedDate;
      });
    }
  }

  void _addToCartClick(ProductDetails data,
      {@required num cartType, @required bool redirectToCart}) {
    removeFocusFromInputField(context);

    String errMsg =
        attributeManager.checkRequiredAttributes(data.productAttributes);
    if (errMsg.isNotEmpty) {
      showSnackBar(context, errMsg, true);
    } else {
      if (data.giftCard?.isGiftCard == true &&
          _giftCardFormKey.currentState.validate()) {
        _giftCardFormKey.currentState.save();
        _bloc.addToCart(
            data.id,
            cartType,
            data,
            attributeManager
                .getSelectedAttributes(AppConstants.productAttributePrefix));
      }
      if (data?.isRental == true && _rentalFormKey.currentState.validate()) {
        _rentalFormKey.currentState.save();
        _bloc.addToCart(
            data.id,
            cartType,
            data,
            attributeManager
                .getSelectedAttributes(AppConstants.productAttributePrefix));
      } else {
        if (data.giftCard?.isGiftCard == false)
          _bloc.addToCart(
              data.id,
              cartType,
              data,
              attributeManager
                  .getSelectedAttributes(AppConstants.productAttributePrefix));
      }
      _bloc.redirectToCart = redirectToCart;
    }
  }

  getProductPrice(ProductPrice productPrice, double fontSize) {
    var priceText = '';
    if (productPrice.callForPrice)
      priceText = _globalService.getString(Const.PRODUCT_CALL_FOR_PRICE);
    else if (productPrice.isRental)
      priceText = productPrice?.rentalPrice ?? '';
    else
      priceText = productPrice?.price ?? '';

    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: priceText,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        TextSpan(text: '   '),
        TextSpan(
          text: productPrice.oldPrice ?? '',
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              decoration: TextDecoration.lineThrough),
        ),
      ]),
    );
  }

  getTierPriceTable(List<TierPrice> tierPrices) {
    if (tierPrices.isEmpty) return SizedBox.shrink();

    var titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        );

    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        children: [
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(_globalService.getString(Const.QUANTITY),
                      style: titleStyle)),
              for (var i = 0; i < tierPrices.length; i++)
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('${tierPrices[i].quantity}+')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(_globalService.getString(Const.PRICE),
                      style: titleStyle)),
              for (var i = 0; i < tierPrices.length; i++)
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('${tierPrices[i].price}')),
            ],
          ),
        ],
      ),
    );
  }

  populateSpecificationAttributes(List<Group> groups) => ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          for (int i = 0; i < groups.length; i++)
            for (int j = 0; j < groups[i].attributes?.length ?? 0; j++)
              SpecificationAttributeItem(attribute: groups[i].attributes[j])
        ],
      );

  populateAssociatedProducts(List<ProductDetails> associatedProducts) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: associatedProducts.length,
      itemBuilder: (context, index) {
        var data = associatedProducts[index];
        return ItemGroupProduct(
          item: data,
          price: !data.productPrice.hidePrices &&
                  !data.addToCart.customerEntersPrice
              ? getProductPrice(data.productPrice, 17)
              : SizedBox.shrink(),
          onClick: (cartType) {
            _addToCartClick(data, cartType: cartType, redirectToCart: false);
          },
        );
      },
    );
  }

  void showSubscriptionPopup(bool isSubscribed, num productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _globalService.getString(isSubscribed
                ? Const.BACK_IN_STOCK_POPUP_TITLE_ALREADY_SUBSCRIBED
                : Const.BACK_IN_STOCK_POPUP_TITLE),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _bloc.changeSubscriptionStatus(productId);
              },
              child: Text(_globalService.getString(isSubscribed
                  ? Const.BACK_IN_STOCK_UNSUBSCRIBED
                  : Const.BACK_IN_STOCK_NOTIFY_ME)),
            ),
          ],
        );
      },
    );
  }
}

class ProductDetailsScreenArguments {
  String name;
  num id;
  ProductDetails productDetails;

  ProductDetailsScreenArguments({
    @required this.id,
    @required this.name,
    this.productDetails,
  });
}
