/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time: 2025-07-15 16:07
 */

import 'package:flutter/material.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';
import 'base/IndicatorActivity.dart';

class IndicatorPage extends StatefulWidget {
  IndicatorPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _IndicatorPageState createState() => new _IndicatorPageState();
}

class _IndicatorPageState extends State<IndicatorPage> {
  late List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.5),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => items[index],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    items = [
      IndicatorItem(
          title: "经典指示器(跟随)",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      title: "经典指示器(跟随)",
                      header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/classical_follow.gif"),
      IndicatorItem(
          title: "经典指示器(不跟随)",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      title: "经典指示器(不跟随)",
                      header:
                          ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/classical_unfollow.gif"),
      IndicatorItem(
          title: "QQ头部指示器",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      reverse: false,
                      title: "QQ头部指示器",
                      header: WaterDropHeader(),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/warterdrop.gif"),
      IndicatorItem(
          title: "经典Material指示器",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      title: "官方Material指示器",
                      header: MaterialClassicHeader(
                        distance: 40,
                      ),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/material_classic.gif"),
      IndicatorItem(
          title: "bezier+circle",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      reverse: false,
                      title: "bezier+circle",
                      header: BezierCircleHeader(
                        dismissType: BezierDismissType.ScaleToCenter,
                      ),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/bezier.gif"),
      IndicatorItem(
          title: "水滴坠落Material指示器",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      reverse: false,
                      title: "水滴坠落Material指示器",
                      header: WaterDropMaterialHeader(color: Colors.red),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/material_waterdrop.gif"),
      IndicatorItem(
          title: "底部指示器(经常显示)",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => IndicatorActivity(
                      title: "底部指示器(经常显示)",
                      header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
                      footer: ClassicFooter(
                        height: 80.0,
                        loadStyle: LoadStyle.ShowAlways,
                      ),
                    )));
          },
          imgRes: "images/loadstyle1.gif"),
      IndicatorItem(
          title: "底部指示器(经常隐藏)",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    RefreshConfiguration.copyAncestor(
                      context: context,
                      child: IndicatorActivity(
                          reverse: false,
                          title: "底部指示器(经常隐藏)",
                          header:
                              ClassicHeader(refreshStyle: RefreshStyle.Follow),
                          footer: ClassicFooter(
                            loadStyle: LoadStyle.HideAlways,
                          )),
                      footerTriggerDistance: -30.0,
                      enableLoadingWhenFailed: true,
                      maxUnderScrollExtent: 100.0,
                    )));
          },
          imgRes: "images/loadstyle2.gif"),
      IndicatorItem(
          title: "底部指示器(只有加载中才显示)",
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    RefreshConfiguration.copyAncestor(
                      context: context,
                      child: RefreshConfiguration.copyAncestor(
                        context: context,
                        child: IndicatorActivity(
                            reverse: false,
                            title: "底部指示器(只有加载中才显示)",
                            header: ClassicHeader(
                                refreshStyle: RefreshStyle.Follow),
                            footer: ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                            )),
                        enableLoadingWhenFailed: true,
                        maxUnderScrollExtent: 100.0,
                        footerTriggerDistance: -45.0,
                      ),
                      enableLoadingWhenFailed: true,
                      footerTriggerDistance: -60.0,
                    )));
          },
          imgRes: "images/loadstyle3.gif"),
    ];
    super.didChangeDependencies();
  }
}

class IndicatorItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IndicatorItemState();
  }

  final Function onClick;

  final String imgRes;

  final String title;

  IndicatorItem(
      {required this.title, required this.imgRes, required this.onClick});
}

class _IndicatorItemState extends State<IndicatorItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () => widget.onClick(),
      child: Card(
        child: Column(
          children: <Widget>[
            Center(
              child: Image.asset(
                widget.imgRes,
                fit: BoxFit.cover,
                width: 180.0,
              ),
            ),
            Center(
              child: Text(widget.title),
            )
          ],
        ),
      ),
    );
  }
}
