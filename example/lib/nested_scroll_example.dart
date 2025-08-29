import 'package:flutter/material.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';

class NestedScrollExample extends StatefulWidget {
  @override
  _NestedScrollExampleState createState() => _NestedScrollExampleState();
}

class _NestedScrollExampleState extends State<NestedScrollExample> {
  final RefreshController _refreshController = RefreshController();
  int _itemCount = 30;

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _itemCount = 30; // 刷新时重置数据
    });
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  void _onLoading() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      if (_itemCount < 50) {
        _itemCount += 10;
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NestedScrollView + SmartRefresher')),
      body: SmartRefresher.builder(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        builder: (context, physics) {
          return NestedScrollView(
            physics: physics,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [],
            body: CustomScrollView(
              physics: physics,
              slivers: [
                // 推荐用官方header，确保刷新逻辑
                ClassicHeader(),
                SliverAppBar(
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Header'),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(
                      title: Text('Item #$index'),
                    ),
                    childCount: _itemCount,
                  ),
                ),
                ClassicFooter(), // 推荐用官方footer，确保加载逻辑
              ],
            ),
          );
        },
      ),
    );
  }
}
