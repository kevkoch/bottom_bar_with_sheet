import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  final double heightCircular;
  final double widthCircular;
  Color themeColor;
  double percentage;
  final Icon icon;
  VoidCallback onPressed;

  CircularProgress(
      {Key key,
      this.heightCircular,
      this.widthCircular,
      this.percentage,
      this.icon,
      this.onPressed})
      : super(key: key);

  @override
  _CircularProgressState createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress>
    with TickerProviderStateMixin {
  AnimationController percentageAnimationController;
  @override
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: widget.heightCircular,
      width: widget.widthCircular,
      child: CustomPaint(
        foregroundPainter: MyPainter(
            lineColor: Colors.transparent,
            completeColor: Colors.blueAccent,
            completePercent: widget.percentage ?? 0,
            width: 2.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            iconSize: 24,
            color: Colors.purple,
            splashColor: Colors.transparent,
            onPressed: widget.onPressed,
          ),
        ),
      ),
    ));
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
