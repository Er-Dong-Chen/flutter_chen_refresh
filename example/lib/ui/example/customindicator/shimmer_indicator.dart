/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time:  2025-07-15 11:05
 */

import 'package:flutter/material.dart';
import '../../../other/shimmer_indicator.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';

class ShimmerIndicatorExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShimmerIndicatorExampleState();
  }
}

/*

      @required Color baseColor,
      @required Color highlightColor,
      this.period = const Duration(milliseconds: 1500),
      this.direction = ShimmerDirection.ltr,

 */
class _ShimmerIndicatorExampleState extends State<ShimmerIndicatorExample> {
  RefreshController _refreshController = RefreshController();
  List<String> data = [
    "1",
    "2",
    "1",
    "2",
    "1",
    "2",
    "1",
    "2",
    "1",
    "2",
    "1",
    "2"
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SmartRefresher(
        header: ShimmerHeader(
          text: Text(
            "PullToRefresh",
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
        ),
        footer: ShimmerFooter(
          text: Text(
            "PullToRefresh",
            style: TextStyle(color: Colors.grey, fontSize: 22),
          ),
        ),
        controller: _refreshController,
        enablePullUp: true,
        child: ListView.builder(
          itemCount: data.length,
          itemExtent: 100.0,
          itemBuilder: (c, i) => Card(),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 2000));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(Duration(milliseconds: 2000));
          for (int i = 0; i < 10; i++) {
            data.add("1");
          }
          setState(() {});
          _refreshController.loadComplete();
        });
  }
}
