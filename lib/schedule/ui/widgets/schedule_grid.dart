import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleGrid extends CustomPaint {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;

  ScheduleGrid(this.fromHour, this.toHour, this.timeLabelsWidth)
      : super(
            painter:
                ScheduleGridCustomPaint(fromHour, toHour, timeLabelsWidth));
}

class ScheduleGridCustomPaint extends CustomPainter {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;

  ScheduleGridCustomPaint(this.fromHour, this.toHour, this.timeLabelsWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1;

    final secondaryPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    var lines = toHour - fromHour;

    lines *= 2;

    for (var i = 0; i < lines; i++) {
      var y = (size.height / lines) * i;

      canvas.drawLine(Offset(0, y), Offset(size.width, y),
          i % 2 == 0 ? paint : secondaryPaint);
    }

    canvas.drawLine(Offset(timeLabelsWidth, 0),
        Offset(timeLabelsWidth, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
