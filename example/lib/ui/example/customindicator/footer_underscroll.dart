/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time:  2025-07-15 10:58
 */

// convert footer to header to use ,behaviour almost same with header

import 'package:flutter/material.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';

import '../../Item.dart';

class ConvertFooter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ConvertFooterState();
  }
}

class _ConvertFooterState extends State<ConvertFooter> {
  RefreshController _refreshController = RefreshController();

  List<String> data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  Widget buildCtn() {
    return ListView.separated(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(left: 5, right: 5),
      itemBuilder: (c, i) => Item(
        title: data[i],
      ),
      separatorBuilder: (context, index) {
        return Container(
          height: 0.5,
          color: Colors.greenAccent,
        );
      },
      itemCount: data.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: RefreshConfiguration.copyAncestor(
        enableBallisticLoad: false,
        footerTriggerDistance: -80,
        maxUnderScrollExtent: 60,
        context: context,
        child: SmartRefresher(
          enablePullUp: true,
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          child: buildCtn(),
          onLoading: () async {
            await Future.delayed(Duration(milliseconds: 1000));
            for (int i = 0; i < 5; i++) data.add("1");

            setState(() {});
            _refreshController.loadFailed();
          },
          controller: _refreshController,
        ),
      ),
      appBar: AppBar(),
    );
  }
}
