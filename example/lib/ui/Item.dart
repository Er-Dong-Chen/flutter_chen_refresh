/*
 * Author: ErDongChen
 * Email: 1251752648@qq.com
 * Time: 2025-07-15 12:22
 */
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final String title;

  Item({required this.title});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Center(
          child: Text(widget.title),
        ),
      ),
      height: 100.0,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
