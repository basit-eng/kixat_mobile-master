import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kixat/customWidget/cached_image.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/pages/product-list/product_list_screen.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/GetBy.dart';
import 'package:kixat/utils/utility.dart';

class HorizontalCategories extends StatelessWidget {
  final List<CategoryTreeResponseData> categories;
  final double boxSize = 100;

  const HorizontalCategories({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkThemeEnabled(context) ? Color(0xFF2D2C2C) : Color(0xFFECEDF4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              GlobalService().getString(Const.HOME_OUR_CATEGORIES).toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            height: boxSize + 40,
            width: double.infinity,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ProductListScreen.routeName,
                          arguments: ProductListScreenArguments(
                            id: categories[index].categoryId,
                            name: categories[index].name,
                            type: GetBy.CATEGORY,
                          )
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 3, 5),
                      child: Column(
                        children: [
                          Card(
                            elevation: 1.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: CpImage(
                                url: categories[index].iconUrl,
                                height: boxSize,
                                width: boxSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          SizedBox(
                              width: boxSize,
                              child: Text(
                                categories[index].name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
