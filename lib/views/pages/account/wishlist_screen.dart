import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolapp/bloc/wishlist_bloc.dart';
import 'package:schoolapp/views/customWidget/CustomAppBar.dart';
import 'package:schoolapp/views/customWidget/CustomButton.dart';
import 'package:schoolapp/views/customWidget/cached_image.dart';
import 'package:schoolapp/views/customWidget/loading.dart';
import 'package:schoolapp/views/customWidget/error.dart';
import 'package:schoolapp/views/customWidget/loading_dialog.dart';
import 'package:schoolapp/model/WishListResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/views/pages/account/cart/shopping_cart_screen.dart';
import 'package:schoolapp/views/pages/product/product_details_screen.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/ButtonShape.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/styles.dart';
import 'package:schoolapp/utils/utility.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key key}) : super(key: key);
  static const routeName = '/wishlist';

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  GlobalService _globalService = GlobalService();
  WishListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WishListBloc();

    _bloc.fetchWishListData();

    _bloc.loaderStream.listen((showLoader) {
      if (showLoader) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    _bloc.launchCartStream.listen((go) {
      if (go) {
        Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
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
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(_globalService.getString(Const.ACCOUNT_WISHLIST)),
      ),
      body: StreamBuilder<ApiResponse<WishListResponse>>(
        stream: _bloc.wishListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchWishListData(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(WishListData data) {
    // update global wishlist counter
    var totalItems = 0;
    data?.items?.forEach((element) {
      totalItems += (element?.quantity ?? 0);
    });
    _globalService.updateWishListCount(totalItems);

    var btnAddAll = CustomButton(
        label: _globalService
            .getString(Const.WISHLIST_ADD_ALL_TO_CART)
            .toUpperCase(),
        shape: ButtonShape.RoundedTop,
        onClick: () {
          // move all items from wishList to cart
          _bloc.moveToCart(data.items?.map((e) => e?.id)?.toList());
        });

    return Stack(
      children: [
        ListView.builder(
          itemCount: (data.items?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index < data.items?.length ?? 0) {
              return wishListItem(data.items[index]);
            } else {
              return SizedBox(height: 50);
            }
          },
        ),
        if (data.displayAddToCart && data.items?.isNotEmpty == true)
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [Expanded(child: btnAddAll)],
            ),
          ),
        if (data.items?.isEmpty == true)
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _globalService.getString(Const.WISHLIST_NO_ITEM),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget wishListItem(WishListItem item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
                arguments: ProductDetailsScreenArguments(
                  id: item.productId,
                  name: item.productName,
                )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CpImage(
                  url: item.picture.imageUrl,
                  width: 120,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 9,
                          child: Text(
                            item.productName ?? '',
                            style: Styles.productNameTextStyle(context),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              _bloc.removeItemFromWishlist(item.id);
                            },
                            child: Icon(Icons.close_outlined),
                          ),
                        ),
                      ],
                    ),
                    Text(
                        '${_globalService.getString(Const.PRICE)}: ${item.unitPrice ?? ''}'),
                    Text(
                        '${_globalService.getString(Const.QUANTITY)}: ${item.quantity ?? ''}'),
                    Text(
                        '${_globalService.getString(Const.TOTAL)}: ${item.subTotal ?? ''}'),
                    if (item.attributeInfo?.isNotEmpty == true)
                      Html(
                        data: item.attributeInfo ?? '',
                        shrinkWrap: true,
                        style: htmlNoPaddingStyle(fontSize: 15),
                      ),
                    OutlinedButton(
                      onPressed: () {
                        _bloc.moveToCart([item.id]);
                      },
                      child: Text(
                        _globalService.getString(Const.PRODUCT_BTN_ADDTOCART),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
