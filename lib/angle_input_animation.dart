import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class WheelPainter extends CustomPainter {
  WheelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final textStyle = TextStyle(
      fontSize: 12,
      height: 14 / 12,
      color: Color.fromRGBO(33, 40, 50, 1),
    );
    for (var angle = -180; angle <= 180; angle += 3) {
      final x = width / 2 + angle / 3 * 10;
      canvas.drawLine(Offset(x, height),
          Offset(x, height - (angle % 15 == 0 ? 22 : 19)), linePaint);

      if (angle % 15 == 0) {
        final textSpan = TextSpan(style: textStyle, text: '$angle');
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _AngleInputLayoutDelegate extends MultiChildLayoutDelegate {
  static final wheel = 'wheel';
  static final anchor = 'anchor';
  static final scrollPad = 'scrollPad';

  @override
  void performLayout(Size size) {
    final width = size.width;
    final height = size.height;

    layoutChild(
        wheel, BoxConstraints.tightFor(width: width, height: 66.0 - 14));
    positionChild(wheel, Offset.zero);

    layoutChild(anchor, BoxConstraints.tightFor(width: 12, height: 40));
    positionChild(anchor, Offset((width - 12) / 2, 66.0 - 40));

    layoutChild(
      scrollPad,
      BoxConstraints.tightFor(width: width, height: height),
    );
    positionChild(wheel, Offset.zero);
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

class AngleInput extends StatefulWidget {
  AngleInput({Key key}) : super(key: key);

  @override
  _AngleInputState createState() => _AngleInputState();
}

class _AngleInputState extends State<AngleInput>
    with SingleTickerProviderStateMixin {
  AnimationController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController.unbounded(
      vsync: this,
      value: 0.0,
    );
    ctrl.addListener(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        child: CustomMultiChildLayout(
          delegate: _AngleInputLayoutDelegate(),
          children: [
            LayoutId(
              id: _AngleInputLayoutDelegate.wheel,
              child: AnimatedBuilder(
                animation: ctrl,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(ctrl.value, 0),
                    child: CustomPaint(
                      painter: WheelPainter(),
                    ),
                  );
                },
              ),
            ),
            LayoutId(
              id: _AngleInputLayoutDelegate.anchor,
              child: Image.asset('images/angle_input_anchor.png'),
            ),
            LayoutId(
              id: _AngleInputLayoutDelegate.scrollPad,
              child: GestureDetector(
                onPanUpdate: (details) {
                  ctrl.value += details.delta.dx;
                },
                onPanEnd: (details) {
                  ctrl.animateWith(FrictionSimulation(
                    0.1,
                    ctrl.value,
                    details.velocity.pixelsPerSecond.dx / 10,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
