/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time:  2025-07-15 13:43
 */

import 'package:flutter/material.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';

/*
    achieve requirement
    tap button to trigger refresh insteal of pull down refresh
 */
class TapButtonRefreshExample extends StatefulWidget {
  TapButtonRefreshExample();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TapButtonRefreshExampleState();
  }
}

class _TapButtonRefreshExampleState extends State<TapButtonRefreshExample> {
  List<String> data = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _enablePullDown = false;

  Widget buildEmpty() {
    // there are two ways
    // this way is more converient,but it doesn't reference ListView some attribute
    // If you don't need some attribute like physics,cacheExtent,just default
    // you can return emptyWidget directly,else return ListView
    // from 1.5.2,you needn't  compute the height by LayoutBuilder,If your boxConstaints is double.infite,
    // SmartRefresher can convert the height to the viewport mainExtent
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "images/empty1.png",
          fit: BoxFit.cover,
        ),
        Text("没数据,请点击按钮刷新")
      ],
    );
    /* second way
    return ListView(
      children: [
        Image.asset(
          "images/empty.png",
          fit: BoxFit.cover,
        )
      ],
      physics: BouncingScrollPhysics(),
      cacheExtent: 100.0,
    );
     */
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController.headerMode?.addListener(() {
      if (_refreshController.headerMode?.value == RefreshStatus.idle) {
        Future.delayed(const Duration(milliseconds: 20)).then((value) {
          _enablePullDown = false;
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: data.length != 0,
        enablePullDown: _enablePullDown,
        header: ClassicHeader(),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 2000));
          if (mounted) {
            setState(() {
              data.add("new");
              data.add("new");
              data.add("new");
              data.add("new");
              data.add("new");
              data.add("new");
            });
          }
          _refreshController.refreshCompleted();
        },
        child: data.length == 0
            ? buildEmpty()
            : ListView.builder(
                itemBuilder: (c, i) => Text(data[i]),
                itemCount: data.length,
                itemExtent: 100.0,
              ),
      ),
      appBar: AppBar(
        title: Text("点击按钮刷新"),
        actions: [
          GestureDetector(
            onTap: () {
              _enablePullDown = true;
              setState(() {});
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _refreshController.requestRefresh();
              });
            },
            child: Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}
