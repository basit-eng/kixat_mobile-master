import 'package:flutter/material.dart';
import 'package:kixat/customWidget/home/manufacturer_box.dart';
import 'package:kixat/customWidget/home/product_box_header.dart';
import 'package:kixat/model/home/ManufacturersResponse.dart';

class HorizontalManufacturerSlider extends StatelessWidget {
  final String title;

  final List<ManufacturerData> manufacturersList;

  HorizontalManufacturerSlider(this.title, this.manufacturersList);

  void goToProductListPage() {
    print('Go to product list page.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductBoxHeader(
          title,
          false,
          false,
          [],
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: manufacturersList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () {
                    goToProductListPage();
                  },
                  child: ManufacturerBox(manufacturersList[index]),
                );
              }),
        ),
      ],
    );
  }
}
