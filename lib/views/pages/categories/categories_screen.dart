import 'package:flutter/material.dart';
import 'package:softify/views/customWidget/category_tree.dart';
import 'package:softify/model/category_tree/CategoryTreeResponse.dart';
import 'package:softify/networking/ApiResponse.dart';

class CategoriesScreen extends StatefulWidget {
  final ApiResponse<CategoryTreeResponse> snapshot;
  CategoriesScreen(this.snapshot);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return CategoryTree(widget.snapshot);
  }
}
