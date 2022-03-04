import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kixat/bloc/category_tree/category_tree_bloc.dart';
import 'package:kixat/model/category_tree/CategoryTreeResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/AppConstants.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/nop_cart_icons.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:kixat/views/customWidget/cached_image.dart';
import 'package:kixat/views/customWidget/category_tree.dart';
import 'package:kixat/views/customWidget/custom_fee.dart';
import 'package:kixat/views/customWidget/notification_screen.dart';
import 'package:kixat/views/pages/account/account_screen.dart';
import 'package:kixat/views/pages/app_bar_cart.dart';
import 'package:kixat/views/pages/categories/categories_screen.dart';
import 'package:kixat/views/pages/drawer.dart';
import 'package:kixat/views/pages/home/home_screen.dart';
import 'package:kixat/views/pages/more/more_screen.dart';
import 'package:kixat/views/pages/notice_screen.dart';
import 'package:kixat/views/pages/report_card.dart';
import 'package:kixat/views/pages/search/search_screen.dart';

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
        'page': ReportCardScreen(),
        'title': "Reports"
        // '${_globalService.getString(Const.HOME_NAV_CATEGORY)}',
      },
      {
        'page': FeeCard(),
        'title': "Fee"
        // '${_globalService.getString(Const.HOME_NAV_SEARCH)}',
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
              'page': ReportCardScreen(),
              'title': "Reports"
              // '${_globalService.getString(Const.HOME_NAV_CATEGORY)}',
            },
            {
              'page': FeeCard(),
              'title': "Fee"
              // '${_globalService.getString(Const.HOME_NAV_SEARCH)}',
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
    if (_selectedPageIndex == index) return;

    setState(() {
      _navigationQueue.removeWhere((element) => element == index);
      _navigationQueue.addLast(index);
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: _selectedPageIndex == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                    height: 40,
                    child: _globalService.getAppLandingData().rtl
                        ? Text(
                            "Softify School System",
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .appBarTheme
                                .textTheme
                                .headline6,

                            // style: TextStyle(
                            //     color: isDarkThemeEnabled(context)
                            //         ? Colors.black45
                            //         : Colors.white,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w800),
                          )
                        : Text(
                            "Softify School System",
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .appBarTheme
                                .textTheme
                                .headline6,

                            // style: TextStyle(
                            //     color: isDarkThemeEnabled(context)
                            //         ? Colors.black45
                            //         : Colors.white,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w800),
                          )
                    // Image(
                    //     image: AssetImage(AppConstants.logo_rtl),
                    //     fit: BoxFit.fill,
                    //   )
                    // : CpImage(
                    //     url: _globalService.getAppLandingData().logoUrl,
                    //     fit: BoxFit.fill,
                    //   ),
                    ),
              )
            : Text(
                _pages[_selectedPageIndex]['title'],
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
        centerTitle: _selectedPageIndex == 0 ?? true,
        leading: _selectedPageIndex != 0
            ? InkWell(
                onTap: () {
                  setState(() {
                    _selectedPageIndex = 0;
                  });
                },
                child: Icon(
                  Icons.arrow_back,
                ),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => NotificationScreen()),
                  ),
                );
              },
              child: Icon(
                Icons.notifications,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: _selectedPageIndex == 0 ? CustomDrawer() : null,
      body: WillPopScope(
        onWillPop: () async {
          if (_navigationQueue.isNotEmpty) {
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
                Icon(Icons.receipt_long_rounded, size: 18),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
            label: _pages[1]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
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
