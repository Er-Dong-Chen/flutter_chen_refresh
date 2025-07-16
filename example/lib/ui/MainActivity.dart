/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time: 2025-07-15 16:13
 */

import 'package:flutter/material.dart';

import 'example/ExamplePage.dart';
import 'indicator/IndicatorPage.dart';
import 'test/TestPage.dart';

class MainActivity extends StatefulWidget {
  final String title;

  MainActivity({required this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainActivityState();
  }
}

class _MainActivityState extends State<MainActivity>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_tabIndex == 0
            ? "指示器界面"
            : _tabIndex == 1
                ? "例子界面"
                : "测试界面"),
        bottom: TabBar(
          isScrollable: true,
          tabs: [
            Tab(child: Text("指示器界面")),
            Tab(child: Text("例子界面")),
            Tab(child: Text("测试界面")),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          IndicatorPage(title: "指示器界面"),
          ExamplePage(),
          TestPage(title: "测试界面"),
        ],
      ),
    );
  }
}
