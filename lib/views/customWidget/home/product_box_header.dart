import 'package:flutter/material.dart';
import 'package:softify/model/home/CategoriesWithProductsResponse.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/GetBy.dart';
import 'package:softify/views/pages/product-list/product_list_screen.dart';

class ProductBoxHeader extends StatelessWidget {
  final GlobalService _globalService = GlobalService();

  final String title;
  final num categoryId;
  final bool showSeeAllBtn;
  final bool showSubcategories;
  final List<CategoriesWithProducts> subcategories;

  ProductBoxHeader(this.title, this.showSeeAllBtn, this.showSubcategories,
      this.subcategories,
      {this.categoryId});

  void openSubcategoriesActionSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              for (var index = 0; index < this.subcategories.length; index++)
                ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .popAndPushNamed(ProductListScreen.routeName,
                            arguments: ProductListScreenArguments(
                              id: subcategories[index].id,
                              name: subcategories[index].name,
                              type: GetBy.CATEGORY,
                            ));
                  },
                  title: Text(
                    subcategories[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var showOverflow = showSubcategories == true && subcategories.length > 0;

    return Row(
      children: [
        SizedBox(
          width: width - (showSeeAllBtn ? 75 : 0) - (showOverflow ? 35 : 5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        Spacer(),
        if (showSeeAllBtn == true)
          SizedBox(
            height: 25,
            width: 75,
            child: OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ProductListScreen.routeName,
                    arguments: ProductListScreenArguments(
                      id: categoryId,
                      name: title,
                      type: GetBy.CATEGORY,
                    ));
              },
              child: Text(
                '${_globalService.getString(Const.COMMON_SEE_ALL)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        if (showOverflow)
          SizedBox(
            width: 35,
            child: IconButton(
              icon: Icon(Icons.more_vert),
              padding: EdgeInsets.zero,
              onPressed: () {
                openSubcategoriesActionSheet(context);
              },
            ),
          ),
        if (!showOverflow)
          SizedBox(
            width: 5,
          )
      ],
    );
  }
}
