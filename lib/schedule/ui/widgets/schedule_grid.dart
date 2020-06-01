import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleGrid extends CustomPaint {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;
  final int verticalLines;

  ScheduleGrid(
      this.fromHour, this.toHour, this.timeLabelsWidth, this.verticalLines)
      : super(
            painter: ScheduleGridCustomPaint(
          fromHour,
          toHour,
          timeLabelsWidth,
          verticalLines,
        ));
}

class ScheduleGridCustomPaint extends CustomPainter {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;
  final int verticalLines;

  ScheduleGridCustomPaint(
    this.fromHour,
    this.toHour,
    this.timeLabelsWidth,
    this.verticalLines,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final secondaryPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    var lines = toHour - fromHour;

    for (var i = 0; i < lines; i++) {
      var y = (size.height / lines) * i;

      canvas.drawLine(Offset(0, y), Offset(size.width, y),
          i % 1 != 0 ? paint : secondaryPaint);
    }

    for (var i = 0; i < verticalLines; i++) {
      var x = ((size.width - timeLabelsWidth) / verticalLines) * i +
          timeLabelsWidth;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), secondaryPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
