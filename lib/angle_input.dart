import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  double scrollViewSize;
  WheelPainter(this.scrollViewSize);

  @override
  void paint(Canvas canvas, Size size) {
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
      final x = scrollViewSize / 2 + (angle + 180) / 3 * 10;
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
    return false;
  }
}

class AngleInfo {
  final double delta;
  final double newAngle;

  AngleInfo(this.delta, this.newAngle);
}

class AngleInput extends StatefulWidget {
  final double initialAngle;
  final ValueChanged<AngleInfo> onChange;

  AngleInput({
    Key key,
    this.initialAngle = 0.0,
    @required this.onChange,
  }) : super(key: key);

  @override
  _AngleInputState createState() => _AngleInputState();
}

class _AngleInputState extends State<AngleInput> {
  ScrollController controller;
  double lastAngle;

  @override
  void initState() {
    super.initState();
    lastAngle = widget.initialAngle;
    controller = ScrollController(
      initialScrollOffset: (widget.initialAngle + 180) / 3 * 10,
    );
    controller.addListener(() {
      final newAngle = controller.offset / 10 * 3 - 180;
      lastAngle = newAngle;
      final info = AngleInfo(newAngle - lastAngle, newAngle);
      widget.onChange(info);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Container(
          height: 66,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Positioned(
                width: width,
                height: 52,
                child: ClipRect(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: CustomPaint(
                      size: Size(1200 + width, 52),
                      painter: WheelPainter(width),
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                child: Stack(
                  children: [
                    Positioned(
                      left: (width - 12) / 2,
                      bottom: 0,
                      width: 12,
                      height: 40,
                      child: Image.asset('images/angle_input_anchor.png'),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
