import 'package:flutter/material.dart';

class TestCanvas extends StatefulWidget {
  TestCanvas({Key key}) : super(key: key);

  @override
  _TestCanvasState createState() => _TestCanvasState();
}

class _TestCanvasState extends State<TestCanvas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 canvas'),
      ),
      body: CustomPaint(
        size: Size(500, 500),
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(50, 50),
        20,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);
    canvas.drawCircle(
        Offset(50, 50),
        20,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
