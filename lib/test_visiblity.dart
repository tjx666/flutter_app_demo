import 'package:flutter/material.dart';

class TestVisibility extends StatefulWidget {
  TestVisibility({Key key}) : super(key: key);

  @override
  _TestVisibilityState createState() => _TestVisibilityState();
}

class _TestVisibilityState extends State<TestVisibility> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 '),
      ),
      body: Column(
        children: [
          Visibility(
            visible: visible,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.blue,
            ),
          ),
          FlatButton(
              onPressed: () {
                setState(() {
                  visible = !visible;
                });
              },
              child: Text(visible ? 'hide' : 'show'))
        ],
      ),
    );
  }
}
