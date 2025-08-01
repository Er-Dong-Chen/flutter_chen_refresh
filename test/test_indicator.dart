/*
    Author: ErDongChen
    Email: 1251752648@qq.com
    createTime: 2025-07-15 20:58  
 */

import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicatorState, RefreshIndicator;

class TestHeader extends RefreshIndicator {
  const TestHeader();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestHeaderState();
  }
}

class _TestHeaderState extends RefreshIndicatorState<TestHeader> {
  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    // TODO: implement buildContent
    return Text(mode == RefreshStatus.idle
        ? "idle"
        : mode == RefreshStatus.refreshing
            ? "refreshing"
            : mode == RefreshStatus.canRefresh
                ? "canRefresh"
                : mode == RefreshStatus.canTwoLevel
                    ? "canTwoLevel"
                    : mode == RefreshStatus.completed
                        ? "completed"
                        : mode == RefreshStatus.failed
                            ? "failed"
                            : mode == RefreshStatus.twoLevelClosing
                                ? "twoLevelClosing"
                                : mode == RefreshStatus.twoLevelOpening
                                    ? "twoLevelOpening"
                                    : "twoLeveling");
  }
}

class TestFooter extends LoadIndicator {
  const TestFooter();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestFooterState();
  }
}

class _TestFooterState extends LoadIndicatorState<TestFooter> {
  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    // TODO: implement buildContent
    return Text(mode == LoadStatus.failed
        ? "failed"
        : mode == LoadStatus.loading
            ? "loading"
            : mode == LoadStatus.idle
                ? "idle"
                : "noData");
  }
}
