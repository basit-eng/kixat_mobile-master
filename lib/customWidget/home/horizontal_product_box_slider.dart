import 'package:flutter/material.dart';
import 'package:kixat/customWidget/home/product_box_header.dart';
import 'package:kixat/customWidget/product%20box/product_box_horizontal.dart';
import 'package:kixat/model/ProductSummary.dart';
import 'package:kixat/model/home/CategoriesWithProductsResponse.dart';

class HorizontalSlider extends StatelessWidget {
  final String title;
  final num categoryId;
  final bool showSeeAllBtn;
  final bool showSubcategories;
  final List<CategoriesWithProducts> subcategories;

  final List<ProductSummary> productList;

  HorizontalSlider(this.title, this.showSeeAllBtn, this.showSubcategories,
      this.subcategories, this.productList, {this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductBoxHeader(
          title,
          showSeeAllBtn,
          showSubcategories,
          subcategories,
          categoryId: this.categoryId
        ),
        SizedBox(
          height: 290, // ProductBox's height depends on it
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                return HorizontalProductBox(productList[index]);
              }),
        ),
      ],
    );
  }
}
