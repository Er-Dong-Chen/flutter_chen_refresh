/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time: 2025-07-15 16:10
 */

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';
import '../../Item.dart';

class IndicatorActivity extends StatefulWidget {
  final String title;

  final Widget header;

  final Widget footer;

  final bool enableOverScroll;
  final bool reverse;

  IndicatorActivity(
      {required this.title,
      required this.header,
      this.reverse = false,
      required this.footer,
      this.enableOverScroll = true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IndicatorActivityState();
  }
}

class _IndicatorActivityState extends State<IndicatorActivity> {
  List<Widget> items = [];
  late RefreshController _refreshController;

  void _init() {
    for (int i = 0; i < 15; i++) {
      items.add(Item(
        title: "Data$i",
      ));
    }
  }

  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = new ScrollController();
    _refreshController = RefreshController();
    Future.delayed(Duration(milliseconds: 3000)).then((_) {
//      _jumpTo(0.0);
    });
    _init();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (c) {
          return SmartRefresher(
              child: ListView.builder(
                itemBuilder: (c, i) => items[i],
                itemExtent: 100.0,
                controller: _scrollController,
                reverse: widget.reverse,
                itemCount: items.length,
              ),
              onRefresh: _onRefresh,
              onLoading: () {
                _onLoading(c);
              },
              header: widget.header,
              footer: widget.footer,
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController);
        },
      ),
    );
  }

  _onRefresh() {
    print("onRefresh");
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      items.add(Item(title: "Data"));
      if (mounted) setState(() {});
      _refreshController.refreshCompleted();
    });
  }

  _onLoading(BuildContext context) {
    print("onLoading");
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      _refreshController.loadComplete();
    });
  }
}
