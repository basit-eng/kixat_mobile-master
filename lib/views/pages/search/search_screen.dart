import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kixat/bloc/search_bloc.dart';
import 'package:kixat/model/SearchResponse.dart';
import 'package:kixat/model/SearchSuggestionResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/styles.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/customWidget/AdvSearchBottomSheet.dart';
import 'package:kixat/views/customWidget/loading.dart';
import 'package:kixat/views/customWidget/search/search_filter.dart';
import 'package:kixat/views/customWidget/search/search_product_list_gridview.dart';
import 'package:kixat/views/pages/product/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController editingController = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  SearchResponse searchResponse;
  GlobalService _globalService = GlobalService();
  SearchBloc _bloc;
  var loaded = false;
  String orderBy;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();

    _bloc.searchPageNumber = 1;
    _bloc.orderBy = '';
    _bloc.price = '';
    _bloc.specs = '';
    _bloc.ms = '';

    _bloc.searchStream.listen((event) {
      setState(() {
        loaded = false;
      });

      if (event.status == Status.COMPLETED) {
        setState(() {
          searchResponse = event.data;
          loaded = true;
        });
      }
    });

    // Get advanced search model
    _bloc.searchProduct();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  refetchProductList() {
    _bloc.searchPageNumber = 1;
    _bloc.orderBy = orderBy;

    _bloc.searchProduct();
  }

  bool hasFilterOption() {
    if (loaded &&
        ((searchResponse
                    .data.catalogProductsModel.specificationFilter.enabled &&
                searchResponse.data.catalogProductsModel.specificationFilter
                        .attributes.length >
                    0) ||
            (searchResponse
                    .data.catalogProductsModel.manufacturerFilter.enabled &&
                searchResponse.data.catalogProductsModel.manufacturerFilter
                        .manufacturers.length >
                    0) ||
            (searchResponse
                .data.catalogProductsModel.priceRangeFilter.enabled)) &&
        searchResponse.data.catalogProductsModel.products.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool hasSortOption() {
    if (loaded &&
        searchResponse.data.catalogProductsModel.allowProductSorting &&
        searchResponse.data.catalogProductsModel.allowProductSorting &&
        searchResponse.data.catalogProductsModel.products.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  openFilterOptions() {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return SearchFilter(searchResponse.data.catalogProductsModel, _bloc);
        });
  }

  openSortOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
                itemCount: searchResponse
                    .data.catalogProductsModel.availableSortOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Close bottom modal sheet
                      Navigator.pop(context);
                      // Reload data with selected sort options
                      orderBy = searchResponse.data.catalogProductsModel
                          .availableSortOptions[index].value;
                      refetchProductList();
                    },
                    title: Text(
                      searchResponse.data.catalogProductsModel
                          .availableSortOptions[index].text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: searchResponse.data.catalogProductsModel
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
    return Stack(children: [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TypeAheadFormField<SearchSuggestionData>(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                controller: editingController,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: _globalService.getString(Const.TITLE_SEARCH),
                  hintText: _globalService.getString(Const.TITLE_SEARCH),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: InkWell(
                    onTap: () => editingController.clear(), // clear input
                    child: Icon(Icons.close_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onSubmitted: (value) => performSearch(value),
              ),
              hideOnEmpty: true,
              debounceDuration: Duration(milliseconds: 350),
              suggestionsCallback: (pattern) async {
                if (pattern.length < 3) return [];
                return await _bloc.fetchSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(suggestion.label ?? ''),
                );
              },
              noItemsFoundBuilder: (_) => SizedBox.shrink(),
              hideOnLoading: false,
              onSuggestionSelected: (suggestion) {
                Navigator.pushNamed(
                  context,
                  ProductDetailsPage.routeName,
                  arguments: ProductDetailsScreenArguments(
                    id: suggestion.productId,
                    name: suggestion.label,
                  ),
                );
              },
            ),
          ),
          StreamBuilder<ApiResponse<SearchData>>(
              stream: _bloc.advSearchStream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.status == Status.COMPLETED)
                  return OutlinedButton.icon(
                    icon: _bloc.advSearchModel.advSearchSelected
                        ? Icon(Icons.check_sharp)
                        : SizedBox.shrink(),
                    onPressed: () => showAdvSearchOptions(),
                    label:
                        Text(_globalService.getString(Const.ADVANCED_SEARCH)),
                  );
                return SizedBox.shrink();
              }),
          if (hasFilterOption() || hasSortOption())
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .3),
                  top: BorderSide(width: .3),
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
                            Text('${_globalService.getString(Const.FILTER)}'),
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
              searchResponse.data.catalogProductsModel.products.length > 0)
            Expanded(
              child: SearchProductListGridView(
                  searchResponse,
                  _bloc.searchQuery,
                  orderBy,
                  _bloc.price,
                  _bloc.specs,
                  _bloc.ms),
            ),
        ],
      ),
      if (loaded &&
          _bloc.searchQuery.isNotEmpty &&
          searchResponse.data.catalogProductsModel.products.length == 0)
        Center(
          child: Text(
              searchResponse.data.catalogProductsModel.noResultMessage ?? ''),
        ),
      if (!loaded)
        Loading(
          loadingMessage: '',
        ),
    ]);
  }

  void performSearch(String query) {
    if (query.isNotEmpty && query.length > 2) {
      _bloc.searchQuery = query;
      _bloc.searchPageNumber = 1;
      _bloc.orderBy = '';
      _bloc.price = '';
      _bloc.specs = '';
      _bloc.ms = '';

      _bloc.searchProduct();
    } else {
      showSnackBar(
          context,
          _globalService.getStringWithNumber(Const.SEARCH_QUERY_LENGTH, 3),
          false);
    }
  }

  void showAdvSearchOptions() {
    removeFocusFromInputField(context);
    var model = _bloc.advSearchModel;
    var isAvdSearchEnabled = _bloc.advSearchModel.advSearchSelected;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AdvSearchBottomSheet(model);
        }).whenComplete(() {
      // update advanced search button icon
      if (_bloc.advSearchModel.advSearchSelected != isAvdSearchEnabled)
        setState(() {});
    });
  }
}
