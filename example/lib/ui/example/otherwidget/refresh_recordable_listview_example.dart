/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time:  2025-07-15 22:44
 */

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/other/refresh_recordable_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chen_refresh/flutter_chen_refresh.dart';

enum _ReorderableListType {
  /// A list tile that contains a [CircleAvatar].
  horizontalAvatar,

  /// A list tile that contains a [CircleAvatar].
  verticalAvatar,

  /// A list tile that contains three lines of text and a checkbox.
  threeLine,
}

class ReorderableListDemo extends StatefulWidget {
  const ReorderableListDemo({Key? key}) : super(key: key);

  static const String routeName = '/material/reorderable-list';

  @override
  _ListDemoState createState() => _ListDemoState();
}

class _ListItem {
  _ListItem(this.value, this.checkState);

  final String value;

  bool checkState;
}

class _ListDemoState extends State<ReorderableListDemo> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController _bottomSheet;
  RefreshController _refreshController = RefreshController();
  _ReorderableListType _itemType = _ReorderableListType.threeLine;
  bool _reverse = false;
  bool _reverseSort = false;
  final List<_ListItem> _items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
  ].map<_ListItem>((String item) => _ListItem(item, false)).toList();

  void changeItemType(_ReorderableListType? type) {
    if (type == null) return;
    if (mounted)
      setState(() {
        _itemType = type;
      });
    _bottomSheet.setState!(() {
      // Trigger a rebuild.
    });
    _bottomSheet.close();
  }

  void changeReverse(bool? newValue) {
    if (newValue == null) return;
    if (mounted)
      setState(() {
        _reverse = newValue;
      });
    _bottomSheet.setState!(() {
      // Trigger a rebuild.
    });
    _bottomSheet.close();
  }

  void _showConfigurationSheet() {
    if (mounted)
      setState(() {
        final currentState = scaffoldKey.currentState;
        if (currentState != null) {
          _bottomSheet =
              currentState.showBottomSheet((BuildContext bottomSheetContext) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black26)),
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  CheckboxListTile(
                    dense: true,
                    title: const Text('Reverse'),
                    value: _reverse,
                    onChanged: changeReverse,
                  ),
                  RadioListTile<_ReorderableListType>(
                    dense: true,
                    title: const Text('Horizontal Avatars'),
                    value: _ReorderableListType.horizontalAvatar,
                    groupValue: _itemType,
                    onChanged: changeItemType,
                  ),
                  RadioListTile<_ReorderableListType>(
                    dense: true,
                    title: const Text('Vertical Avatars'),
                    value: _ReorderableListType.verticalAvatar,
                    groupValue: _itemType,
                    onChanged: changeItemType,
                  ),
                  RadioListTile<_ReorderableListType>(
                    dense: true,
                    title: const Text('Three-line'),
                    value: _ReorderableListType.threeLine,
                    groupValue: _itemType,
                    onChanged: changeItemType,
                  ),
                ],
              ),
            );
          });
          _bottomSheet.closed.whenComplete(() {
            if (mounted) {
              setState(() {
                // 不能直接赋null，late变量不允许
              });
            }
          });
        }
      });
  }

  Widget buildListTile(_ListItem item) {
    const Widget secondary = Text(
      'Even more additional list item information appears on line three.',
    );
    Widget listTile;
    switch (_itemType) {
      case _ReorderableListType.threeLine:
        listTile = CheckboxListTile(
          key: Key(item.value),
          isThreeLine: true,
          value: item.checkState,
          onChanged: (bool? newValue) {
            if (mounted)
              setState(() {
                item.checkState = newValue ?? false;
              });
          },
          title: Text('This item represents ${item.value}.'),
          subtitle: secondary,
          secondary: const Icon(Icons.drag_handle),
        );
        break;
      case _ReorderableListType.horizontalAvatar:
      case _ReorderableListType.verticalAvatar:
        listTile = Container(
          key: Key(item.value),
          height: 100.0,
          width: 100.0,
          child: CircleAvatar(
            child: Text(item.value),
            backgroundColor: Colors.green,
          ),
        );
        break;
    }
    return listTile;
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (mounted)
      setState(() {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final _ListItem item = _items.removeAt(oldIndex);
        _items.insert(newIndex, item);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Reorderable list'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: 'Sort',
            onPressed: () {
              if (mounted)
                setState(() {
                  _reverseSort = !_reverseSort;
                  _items.sort((_ListItem a, _ListItem b) => _reverseSort
                      ? b.value.compareTo(a.value)
                      : a.value.compareTo(b.value));
                });
            },
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Icons.more_horiz
                  : Icons.more_vert,
            ),
            tooltip: 'Show menu',
            onPressed: _bottomSheet == null ? _showConfigurationSheet : null,
          ),
        ],
      ),
      body: Scrollbar(
        child: RefreshReorderableListView(
          header: _itemType != _ReorderableListType.threeLine
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Header of the list',
                      style: Theme.of(context).textTheme.headlineLarge))
              : null,
          onReorder: _onReorder,
          reverse: _reverse,
          scrollDirection: _itemType == _ReorderableListType.horizontalAvatar
              ? Axis.horizontal
              : Axis.vertical,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: _items.map<Widget>(buildListTile).toList(),
          refreshController: _refreshController,
        ),
      ),
    );
  }
}
