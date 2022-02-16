import 'package:flutter/material.dart';
import 'package:kixat/bloc/product_list/product_list_bloc.dart';
import 'package:kixat/customWidget/CustomAppBar.dart';
import 'package:kixat/customWidget/loading.dart';
import 'package:kixat/customWidget/product%20list/filter.dart';
import 'package:kixat/customWidget/product%20list/product_list_gridview.dart';
import 'package:kixat/model/product_list/ProductListResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/styles.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = 'product-list';
  final String type;
  final String name;
  final int id;

  ProductListScreen(this.type, this.name, this.id);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  GlobalService _globalService = GlobalService();
  ProductListBloc _bloc = ProductListBloc();

  ProductListResponse productList;
  var loaded = false;
  bool hasInitialProductsLength = false;
  String orderBy = '';
  String price = '';
  String specs = '';
  String ms = '';
  bool showFilterOptions = false;

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bloc.prodListStream.listen((event) {
      setState(() {
        loaded = false;
      });

      if (event.status == Status.COMPLETED) {
        if (event.data.data.catalogProductsModel.products.length > 0 &&
            !hasInitialProductsLength) {
          hasInitialProductsLength = true;
        }
        setState(() {
          productList = event.data;
          loaded = true;
        });
      }
    });

    _bloc.type = widget.type;
    _bloc.categoryId = widget.id;
    _bloc.pageNumber = 1;
    _bloc.orderBy = '';
    _bloc.price = '';
    _bloc.specs = '';
    _bloc.ms = '';

    _bloc.fetchProductList();
  }

  refetchProductList() {
    _bloc.pageNumber = 1;
    _bloc.orderBy = orderBy;

    _bloc.fetchProductList();
  }

  goToProductListPage(String name, int id) {
    // Go to product list page
    Navigator.pushNamed(context, ProductListScreen.routeName,
        arguments:
            ProductListScreenArguments(type: widget.type, name: name, id: id));
  }

  bool hasFilterOption() {
    if (loaded &&
        ((productList.data.catalogProductsModel.specificationFilter.enabled &&
                productList.data.catalogProductsModel.specificationFilter
                        .attributes.length >
                    0) ||
            (productList.data.catalogProductsModel.manufacturerFilter.enabled &&
                productList.data.catalogProductsModel.manufacturerFilter
                        .manufacturers.length >
                    0) ||
            (productList.data.catalogProductsModel.priceRangeFilter.enabled)) &&
        (productList.data.catalogProductsModel.products.length > 0 ||
            hasInitialProductsLength)) {
      return true;
    } else {
      return false;
    }
  }

  bool hasSortOption() {
    if (loaded &&
        productList.data.catalogProductsModel.allowProductSorting &&
        productList.data.catalogProductsModel.allowProductSorting &&
        (productList.data.catalogProductsModel.products.length > 0 ||
            hasInitialProductsLength)) {
      return true;
    } else {
      return false;
    }
  }

  bool hasSubcategories() {
    if (loaded && (productList.data?.subCategories?.length ?? 0) > 0) {
      return true;
    } else {
      return false;
    }
  }

  openSubcategories() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
                itemCount: productList.data.subCategories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      goToProductListPage(
                          productList.data.subCategories[index].name,
                          productList.data.subCategories[index].id);
                    },
                    title: Text(
                      productList.data.subCategories[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                  );
                }),
          );
        });
  }

  openFilterOptions() {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Filter(productList.data.catalogProductsModel, _bloc);
        });
  }

  openSortOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
                itemCount: productList
                    .data.catalogProductsModel.availableSortOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Close bottom modal sheet
                      Navigator.pop(context);
                      // Reload data with selected sort options
                      orderBy = productList.data.catalogProductsModel
                          .availableSortOptions[index].value;
                      refetchProductList();
                    },
                    title: Text(
                      productList.data.catalogProductsModel
                          .availableSortOptions[index].text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: productList.data.catalogProductsModel
                                .availableSortOptions[index].selected
                            ? Theme.of(context).primaryColor
                            : Styles.textColor(context),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          widget.name,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (hasSubcategories())
                InkWell(
                  onTap: () {
                    openSubcategories();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: .5),
                      ),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_downward),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              if (hasFilterOption() || hasSortOption())
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: .3),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (hasFilterOption())
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              openFilterOptions();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${_globalService.getString(Const.FILTER)}'),
                                Icon(
                                  Icons.filter_alt_rounded,
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        width: .5,
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      if (hasSortOption())
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              openSortOptions();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${_globalService.getString(Const.CATALOG_ORDER_BY)}'),
                                Icon(
                                  Icons.sort,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (loaded &&
                  productList.data.catalogProductsModel.products.length > 0)
                Expanded(
                  child: ProductListGridView(widget.type, widget.id,
                      productList, orderBy, price, specs, ms),
                ),
            ],
          ),
          if (loaded &&
              productList.data.catalogProductsModel.products.length == 0)
            Center(
              child: Text(
                '${_globalService.getString(Const.COMMON_NO_DATA)}',
              ),
            ),
          if (!loaded)
            Loading(
              loadingMessage: '',
            )
        ],
      ),
    );
  }
}

class ProductListScreenArguments {
  String type;
  String name;
  num id;

  ProductListScreenArguments({this.type, this.name, this.id});
}
