import 'package:flutter/material.dart';
import 'package:kixat/bloc/product_list/product_list_bloc.dart';
import 'package:kixat/customWidget/loading.dart';
import 'package:kixat/customWidget/product%20box/product_box.dart';
import 'package:kixat/model/ProductSummary.dart';
import 'package:kixat/model/product_list/ProductListResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';

class ProductListGridView extends StatefulWidget {
  final String type;
  final int id;
  final ProductListResponse productList;
  final String orderBy;
  final String price;
  final String specs;
  final String ms;

  ProductListGridView(this.type, this.id, this.productList, this.orderBy,
      this.price, this.specs, this.ms);

  @override
  _ProductListGridViewState createState() => _ProductListGridViewState();
}

class _ProductListGridViewState extends State<ProductListGridView> {
  List<ProductSummary> productArray = [];
  ScrollController _scrollController = new ScrollController();
  ProductListBloc _bloc = ProductListBloc();
  int currentPage;
  int totalPages;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
    _scrollController.removeListener(() {});
  }

  @override
  void initState() {
    super.initState();

    currentPage = widget.productList.data.catalogProductsModel.pageNumber + 1;
    totalPages = widget.productList.data.catalogProductsModel.totalPages;
    productArray.addAll(widget.productList.data.catalogProductsModel.products);

    _bloc.prodListStream.listen((event) {
      if (event.status == Status.LOADING) {
        setState(() {
          loading = true;
        });
      }

      if (event.status == Status.COMPLETED) {
        setState(() {
          loading = false;
          if (currentPage != 1) {
            productArray.addAll(event.data.data.catalogProductsModel.products);
          }
        });
        print('Length ${productArray.length}');

        currentPage++;
        // Disabling infinite scrolling and disposing bloc when last page is reached
        if (currentPage > totalPages) {
          _bloc.dispose();
          _scrollController.removeListener(() {});
        }
      }
    });

    _scrollController.addListener(() {
      // Listening while at the bottom of the page
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange &&
          currentPage <= totalPages) {
        _bloc.type = widget.type;
        _bloc.categoryId = widget.id;
        _bloc.pageNumber = currentPage;
        _bloc.orderBy = widget.orderBy;
        _bloc.price = widget.price;
        _bloc.specs = widget.specs;
        _bloc.ms = widget.ms;
        _bloc.fetchProductList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GridView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return ProductBox(productArray[index]);
        },
        itemCount: productArray.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width / 175).round(),
            childAspectRatio: 175 / 300,
            mainAxisExtent: 300),
        scrollDirection: Axis.vertical,
      ),
      if (loading)
        Loading(
          loadingMessage: '',
        ),
    ]);
  }
}
