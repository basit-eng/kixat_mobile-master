import 'package:flutter/material.dart';
import 'package:schoolapp/model/ProductSummary.dart';
import 'package:schoolapp/model/home/CategoriesWithProductsResponse.dart';
import 'package:schoolapp/views/customWidget/home/product_box_header.dart';
import 'package:schoolapp/views/customWidget/product%20box/product_box_horizontal.dart';

class HorizontalSlider extends StatelessWidget {
  final String title;
  final num categoryId;
  final bool showSeeAllBtn;
  final bool showSubcategories;
  final List<CategoriesWithProducts> subcategories;

  final List<ProductSummary> productList;

  HorizontalSlider(this.title, this.showSeeAllBtn, this.showSubcategories,
      this.subcategories, this.productList,
      {this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductBoxHeader(title, showSeeAllBtn, showSubcategories, subcategories,
            categoryId: this.categoryId),
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
