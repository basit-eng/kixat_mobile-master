import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kixat/bloc/category_tree/category_tree_bloc.dart';
import 'package:kixat/customWidget/CustomAppBar.dart';
import 'package:kixat/customWidget/cached_image.dart';
import 'package:kixat/customWidget/category_tree.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/pages/account/account_screen.dart';
import 'package:kixat/pages/app_bar_cart.dart';
import 'package:kixat/pages/categories/categories_screen.dart';
import 'package:kixat/pages/home/home_screen.dart';
import 'package:kixat/pages/more/more_screen.dart';
import 'package:kixat/pages/search/search_screen.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/AppConstants.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/nop_cart_icons.dart';
import 'package:kixat/utils/utility.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  GlobalService _globalService = GlobalService();
  ListQueue<int> _navigationQueue = ListQueue(0);

  CategoryTreeBloc _bloc;

  ApiResponse<CategoryTreeResponse> snapshot;
  var loaded = false;

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': HomeScreen(categories: []),
        'title': '${_globalService.getString(Const.HOME_NAV_HOME)}',
      },
      {
        'page': Container(),
        'title': '${_globalService.getString(Const.HOME_NAV_CATEGORY)}',
      },
      {
        'page': SearchScreen(),
        'title': '${_globalService.getString(Const.HOME_NAV_SEARCH)}',
      },
      {
        'page': AccountScreen(),
        'title': '${_globalService.getString(Const.HOME_NAV_ACCOUNT)}',
      },
      {
        'page': MoreScreen(),
        'title': '${_globalService.getString(Const.HOME_NAV_MORE)}',
      },
    ];

    _bloc = CategoryTreeBloc();
    _bloc.fetchCategoryTree();

    _bloc.categoryTreeStream.listen((event) {
      print(event);
      if (event.status == Status.COMPLETED) {
        setState(() {
          snapshot = event;
          loaded = true;
          _pages = [
            {
              'page': HomeScreen(categories: snapshot?.data?.data ?? []),
              'title': '${_globalService.getString(Const.HOME_NAV_HOME)}',
            },
            {
              'page': CategoriesScreen(snapshot),
              'title': '${_globalService.getString(Const.HOME_NAV_CATEGORY)}',
            },
            {
              'page': SearchScreen(),
              'title': '${_globalService.getString(Const.HOME_NAV_SEARCH)}',
            },
            {
              'page': AccountScreen(),
              'title': '${_globalService.getString(Const.HOME_NAV_ACCOUNT)}',
            },
            {
              'page': MoreScreen(),
              'title': '${_globalService.getString(Const.HOME_NAV_MORE)}',
            },
          ];
        });
      }
    });
  }

  void _selectPage(int index) {
    if(_selectedPageIndex == index)
      return;

    setState(() {
      _navigationQueue.removeWhere((element) => element == index);
      _navigationQueue.addLast(index);
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _selectedPageIndex == 0
            ? SizedBox(
                height: 40,
                child: _globalService.getAppLandingData().rtl?
                Image(image: AssetImage(AppConstants.logo_rtl), fit: BoxFit.fill,):
                CpImage(
                  url: _globalService.getAppLandingData().logoUrl,
                  fit: BoxFit.fill,
                ),
              )
            : Text(
                _pages[_selectedPageIndex]['title'],
                style: Theme.of(context).appBarTheme.textTheme.headline6,
              ),
        centerTitle: _selectedPageIndex == 0,
        leading: _selectedPageIndex != 0
            ? InkWell(
                onTap: () {
                  setState(() {
                    _selectedPageIndex = 0;
                  });
                },
                child: Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          AppBarCart(),
        ],
      ),
      drawer: _selectedPageIndex == 0
          ? Drawer(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: isDarkThemeEnabled(context) ? Colors.grey[800] : Colors.grey[300],
                    height: 85,
                    child: Text(
                      '${_globalService.getString(Const.HOME_NAV_CATEGORY)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (loaded) CategoryTree(snapshot),
                ],
              ),
            )
          : null,
      body: WillPopScope(
        onWillPop: () async {
          if(_navigationQueue.isNotEmpty) {
            _navigationQueue.removeLast();
            int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
            _selectPage(position);
          }
          return _navigationQueue.isEmpty;
        },
        child: IndexedStack(
            index: _selectedPageIndex,
            children: _pages.map<Widget>((e) => e['page']).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(NopCart.ic_home),
            label: _pages[0]['title'],
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(NopCart.ic_category, size: 18),
                SizedBox(height: 3,),
              ],
            ),
            label: _pages[1]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(NopCart.ic_search),
            label: _pages[2]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(NopCart.ic_account),
            label: _pages[3]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            label: _pages[4]['title'],
          ),
        ],
      ),
    );
  }
}
