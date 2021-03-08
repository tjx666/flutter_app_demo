import 'package:flutter/material.dart';

class TestCompositionProgress extends StatefulWidget {
  TestCompositionProgress({Key key}) : super(key: key);

  @override
  _TestCompositionProgressState createState() =>
      _TestCompositionProgressState();
}

class _TestCompositionProgressState extends State<TestCompositionProgress> {
  void showCompositionProgress() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 100,
              left: 100,
              width: 200,
              height: 400,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text('10%'),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 '),
      ),
      body: Container(
        child: Center(
          child: FlatButton(
            child: Text('show dialog'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
