import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TestMultiChildLayout extends StatefulWidget {
  TestMultiChildLayout({Key key}) : super(key: key);

  @override
  _TestMultiChildLayoutState createState() => _TestMultiChildLayoutState();
}

class _TestMultiChildLayoutState extends State<TestMultiChildLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('测试 canvas'),
        ),
        body: CustomMultiChildLayout(
          delegate: ChildrenLayout(),
          children: [
            LayoutId(
              id: 'red',
              child: Container(
                color: Colors.red,
              ),
            ),
            LayoutId(
              id: 'blue',
              child: Container(
                color: Colors.blue,
              ),
            )
          ],
        ));
  }
}

class ChildrenLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    layoutChild('red', BoxConstraints.tightFor(width: 100, height: 10));
    positionChild('red', Offset(15, 10));
    layoutChild('blue', BoxConstraints.tightFor(width: 20, height: 20));
    positionChild('blue', Offset(15, 5));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    throw UnimplementedError();
  }
}
