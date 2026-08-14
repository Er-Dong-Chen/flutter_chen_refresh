/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time:  2025-07-15
*/
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';
import 'package:flutter/widgets.dart';

/// enable header link other header place outside the viewport
class LinkHeader extends RefreshIndicator {
  /// the key that widget outside viewport indicator
  final Key linkKey;

  const LinkHeader(
      {Key? key,
      required this.linkKey,
      double height = 0.0,
      RefreshStyle? refreshStyle,
      Duration completeDuration = const Duration(milliseconds: 200)})
      : super(
            height: height,
            refreshStyle: refreshStyle,
            completeDuration: completeDuration,
            key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LinkHeaderState();
  }
}

class _LinkHeaderState extends RefreshIndicatorState<LinkHeader> {
  RefreshProcessor? get _linkedProcessor {
    final Key key = widget.linkKey;
    assert(key is GlobalKey, 'LinkHeader.linkKey must be a GlobalKey.');
    if (key is! GlobalKey) return null;
    final State? state = key.currentState;
    assert(state == null || state is RefreshProcessor,
        'The state linked by LinkHeader must implement RefreshProcessor.');
    return state is RefreshProcessor ? state as RefreshProcessor : null;
  }

  @override
  void resetValue() {
    _linkedProcessor?.resetValue();
  }

  @override
  Future<void> endRefresh() {
    return _linkedProcessor?.endRefresh() ?? super.endRefresh();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    _linkedProcessor?.onModeChange(mode);
  }

  @override
  void onOffsetChange(double offset) {
    _linkedProcessor?.onOffsetChange(offset);
  }

  @override
  Future<void> readyToRefresh() {
    return _linkedProcessor?.readyToRefresh() ?? super.readyToRefresh();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    // TODO: implement buildContent
    return Container();
  }
}

/// enable footer link other footer place outside the viewport
class LinkFooter extends LoadIndicator {
  /// the key that widget outside viewport indicator
  final Key linkKey;

  const LinkFooter(
      {Key? key,
      required this.linkKey,
      double height = 0.0,
      LoadStyle loadStyle = LoadStyle.ShowAlways})
      : super(height: height, loadStyle: loadStyle, key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LinkFooterState();
  }
}

class _LinkFooterState extends LoadIndicatorState<LinkFooter> {
  LoadingProcessor? get _linkedProcessor {
    final Key key = widget.linkKey;
    assert(key is GlobalKey, 'LinkFooter.linkKey must be a GlobalKey.');
    if (key is! GlobalKey) return null;
    final State? state = key.currentState;
    assert(state == null || state is LoadingProcessor,
        'The state linked by LinkFooter must implement LoadingProcessor.');
    return state is LoadingProcessor ? state as LoadingProcessor : null;
  }

  @override
  void onModeChange(LoadStatus? mode) {
    _linkedProcessor?.onModeChange(mode);
  }

  @override
  void onOffsetChange(double offset) {
    _linkedProcessor?.onOffsetChange(offset);
  }

  @override
  Future readyToLoad() {
    return _linkedProcessor?.readyToLoad() ?? super.readyToLoad();
  }

  @override
  Future endLoading() {
    return _linkedProcessor?.endLoading() ?? super.endLoading();
  }

  @override
  void resetValue() {
    _linkedProcessor?.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    // TODO: implement buildContent
    return Container();
  }
}
