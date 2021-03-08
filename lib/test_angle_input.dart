import 'package:flutter/material.dart';
import 'package:flutter_app_demo/angle_input.dart';

class TestAngleInput extends StatefulWidget {
  TestAngleInput({Key key}) : super(key: key);

  @override
  _TestAngleInputState createState() => _TestAngleInputState();
}

class _TestAngleInputState extends State<TestAngleInput> {
  double angle = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试角度选择器'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('current angle: $angle'),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              child: AngleInput(
                onChange: (info) {
                  setState(() {
                    angle = info.newAngle;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
