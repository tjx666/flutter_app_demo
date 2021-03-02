import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class HSVColorPainter extends CustomPainter {
  const HSVColorPainter(this.hsvColor);
  final HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.black],
    );
    final Gradient gradientH = LinearGradient(
      colors: [
        Colors.white,
        HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.multiply
        ..shader = gradientH.createShader(rect),
    );

    canvas.drawCircle(
      Offset(
          size.width * hsvColor.saturation, size.height * (1 - hsvColor.value)),
      12,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ThumbPainter extends CustomPainter {
  const ThumbPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final radius = 12.0;
    final shadowPath = Path()
      ..addArc(
        Rect.fromCenter(
            center: Offset(0, 4), width: radius * 2, height: radius * 2),
        0,
        pi * 2,
      );

    double convertRadiusToSigma(double radius) {
      return radius * 0.57735 + 0.5;
    }

    canvas.drawPath(
        shadowPath,
        Paint()
          ..color = Color(0xff99a0aa).withOpacity(0.4769)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(3)));
    canvas.drawCircle(
        Offset(0, 4),
        12,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrackPainter extends CustomPainter {
  const TrackPainter(this.hsvColor);

  final HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final colors = <Color>[
      const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
    ];
    Gradient gradient = LinearGradient(colors: colors);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _SliderLayout extends MultiChildLayoutDelegate {
  static final String track = 'track';
  static final String thumb = 'thumb';
  static final String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    layoutChild(
      track,
      BoxConstraints.tightFor(
        width: size.width - 32,
        height: 8,
      ),
    );
    positionChild(track, Offset(16.0, 12));
    layoutChild(
      thumb,
      BoxConstraints.tightFor(width: 12, height: 8),
    );
    positionChild(thumb, Offset(0, 12));
    layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

class ColorPickerSlider extends StatelessWidget {
  const ColorPickerSlider(
    this.hsvColor,
    this.onColorChanged,
  );

  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;

  void slideEvent(RenderBox getBox, BoxConstraints box, Offset globalPosition) {
    final localDx = getBox.globalToLocal(globalPosition).dx - 16.0;
    final progress =
        localDx.clamp(0.0, box.maxWidth - 32.0) / (box.maxWidth - 32.0);
    // 360 is the same as zero
    // if set to 360, sliding to end goes to zero
    onColorChanged(hsvColor.withHue(progress * 359));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final thumbOffset = 16.0 + (box.maxWidth - 32.0) * hsvColor.hue / 360;

      return CustomMultiChildLayout(
        delegate: _SliderLayout(),
        children: <Widget>[
          LayoutId(
            id: _SliderLayout.track,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: CustomPaint(painter: TrackPainter(hsvColor)),
            ),
          ),
          LayoutId(
            id: _SliderLayout.thumb,
            child: Transform.translate(
              offset: Offset(thumbOffset, 0.0),
              child: CustomPaint(
                painter: ThumbPainter(),
              ),
            ),
          ),
          LayoutId(
            id: _SliderLayout.gestureContainer,
            child: LayoutBuilder(
              builder: (context, box) {
                RenderBox getBox = context.findRenderObject();
                return GestureDetector(
                  onPanDown: (details) =>
                      slideEvent(getBox, box, details.globalPosition),
                  onPanUpdate: (details) =>
                      slideEvent(getBox, box, details.globalPosition),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class AlwaysWinPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => 'alwaysWin';
}

class ColorPickerArea extends StatelessWidget {
  const ColorPickerArea(
    this.hsvColor,
    this.onColorChanged,
  );

  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;

  void _handleColorChange(double horizontal, double vertical) {
    onColorChanged(hsvColor.withSaturation(horizontal).withValue(vertical));
  }

  void _handleGesture(
      Offset position, BuildContext context, double height, double width) {
    RenderBox getBox = context.findRenderObject();
    final localOffset = getBox.globalToLocal(position);
    final horizontal = localOffset.dx.clamp(0.0, width) / width;
    final vertical = 1 - localOffset.dy.clamp(0.0, height) / height;
    _handleColorChange(horizontal, vertical);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return RawGestureDetector(
          gestures: {
            AlwaysWinPanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                AlwaysWinPanGestureRecognizer>(
              () => AlwaysWinPanGestureRecognizer(),
              (instance) {
                instance
                  ..onDown = ((details) => _handleGesture(
                      details.globalPosition, context, height, width))
                  ..onUpdate = ((details) => _handleGesture(
                      details.globalPosition, context, height, width));
              },
            ),
          },
          child: Builder(
            builder: (_) {
              return CustomPaint(painter: HSVColorPainter(hsvColor));
            },
          ),
        );
      },
    );
  }
}

class ColorPicker extends StatefulWidget {
  ColorPicker({
    Key key,
    @required this.pickerColor,
    @required this.onColorChanged,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  HSVColor currentHSVColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final paddingWidth = 16.0;
      final pickAreaHeight = 128.0;
      final pickAreaWidth = width - paddingWidth * 2;
      if (currentHSVColor == null) {
        final initOffset = 13;
        currentHSVColor = HSVColor.fromAHSV(1.0, 0.0,
            initOffset / pickAreaWidth, 1 - (initOffset / pickAreaHeight));
      }

      return Column(
        children: [
          SizedBox(
            width: pickAreaWidth,
            height: pickAreaHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ColorPickerArea(currentHSVColor, (color) {
                setState(() => currentHSVColor = color);
                widget.onColorChanged(currentHSVColor.toColor());
              }),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 32,
            width: width,
            child: ColorPickerSlider(currentHSVColor, (color) {
              setState(() => currentHSVColor = color);
              widget.onColorChanged(currentHSVColor.toColor());
            }),
          )
        ],
      );
    });
  }
}
