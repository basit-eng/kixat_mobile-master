import 'package:flutter/material.dart';
import 'package:schoolapp/model/category_tree/CategoryTreeResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/views/customWidget/cached_image.dart';
import 'package:schoolapp/views/pages/product-list/product_list_screen.dart';

class CategoryTree extends StatefulWidget {
  final ApiResponse<CategoryTreeResponse> snapshot;
  CategoryTree(this.snapshot);

  @override
  _CategoryTreeState createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<CategoryTree> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 85,
      child: ListView.builder(
          itemCount: widget.snapshot.data.data.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index1) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: CpImage(
                            url: widget.snapshot.data.data[index1].iconUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Go to product list page
                          Navigator.pushNamed(
                              context, ProductListScreen.routeName,
                              arguments: ProductListScreenArguments(
                                  type: 'categoryTree',
                                  name: widget.snapshot.data.data[index1].name,
                                  id: widget
                                      .snapshot.data.data[index1].categoryId));
                        },
                        child: Text(
                          widget.snapshot.data.data[index1].name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      if (widget
                              .snapshot.data.data[index1].subCategories.length >
                          0)
                        Container(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.snapshot.data.data[index1].isExpanded =
                                    !widget
                                        .snapshot.data.data[index1].isExpanded;
                              });
                            },
                            child: widget.snapshot.data.data[index1].isExpanded
                                ? Icon(Icons.keyboard_arrow_down_sharp)
                                : Icon(Icons.chevron_right),
                          ),
                        ),
                    ],
                  ), //* Level 1
                  if (widget.snapshot.data.data[index1].subCategories.length >
                          0 &&
                      widget.snapshot.data.data[index1].isExpanded)
                    Container(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget
                              .snapshot.data.data[index1].subCategories.length,
                          itemBuilder: (context, index2) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: CpImage(
                                          url: widget.snapshot.data.data[index1]
                                              .subCategories[index2].iconUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            ProductListScreen.routeName,
                                            arguments:
                                                ProductListScreenArguments(
                                                    type: 'categoryTree',
                                                    name: widget
                                                        .snapshot
                                                        .data
                                                        .data[index1]
                                                        .subCategories[index2]
                                                        .name,
                                                    id: widget
                                                        .snapshot
                                                        .data
                                                        .data[index1]
                                                        .subCategories[index2]
                                                        .categoryId));
                                      },
                                      child: Text(
                                        widget.snapshot.data.data[index1]
                                            .subCategories[index2].name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    if (widget
                                            .snapshot
                                            .data
                                            .data[index1]
                                            .subCategories[index2]
                                            .subCategories
                                            .length >
                                        0)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget
                                                    .snapshot
                                                    .data
                                                    .data[index1]
                                                    .subCategories[index2]
                                                    .isExpanded =
                                                !widget
                                                    .snapshot
                                                    .data
                                                    .data[index1]
                                                    .subCategories[index2]
                                                    .isExpanded;
                                          });
                                        },
                                        child: widget
                                                .snapshot
                                                .data
                                                .data[index1]
                                                .subCategories[index2]
                                                .isExpanded
                                            ? Icon(
                                                Icons.keyboard_arrow_down_sharp,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.chevron_right,
                                                size: 20,
                                              ),
                                      ),
                                  ],
                                ), //* Level 2
                                if (widget
                                            .snapshot
                                            .data
                                            .data[index1]
                                            .subCategories[index2]
                                            .subCategories
                                            .length >
                                        0 &&
                                    widget.snapshot.data.data[index1]
                                        .subCategories[index2].isExpanded)
                                  Container(
                                    child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: widget
                                            .snapshot
                                            .data
                                            .data[index1]
                                            .subCategories[index2]
                                            .subCategories
                                            .length,
                                        itemBuilder: (context, index3) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 35,
                                              ),
                                              Container(
                                                height: 40,
                                                width: 40,
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: CpImage(
                                                    url: widget
                                                        .snapshot
                                                        .data
                                                        .data[index1]
                                                        .subCategories[index2]
                                                        .subCategories[index3]
                                                        .iconUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      ProductListScreen
                                                          .routeName,
                                                      arguments: ProductListScreenArguments(
                                                          type: 'categoryTree',
                                                          name: widget
                                                              .snapshot
                                                              .data
                                                              .data[index1]
                                                              .subCategories[
                                                                  index2]
                                                              .subCategories[
                                                                  index3]
                                                              .name,
                                                          id: widget
                                                              .snapshot
                                                              .data
                                                              .data[index1]
                                                              .subCategories[
                                                                  index2]
                                                              .subCategories[
                                                                  index3]
                                                              .categoryId));
                                                },
                                                child: Text(
                                                  widget
                                                      .snapshot
                                                      .data
                                                      .data[index1]
                                                      .subCategories[index2]
                                                      .subCategories[index3]
                                                      .name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ); //* Level 3
                                        }),
                                  ),
                              ],
                            );
                          }),
                    ),
                ],
              ),
            );
          }),
    );
  }
}
