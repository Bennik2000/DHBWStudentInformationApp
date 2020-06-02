import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleGrid extends CustomPaint {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;
  final double dateLabelsHeight;
  final int columns;

  ScheduleGrid(this.fromHour, this.toHour, this.timeLabelsWidth,
      this.dateLabelsHeight, this.columns)
      : super(
            painter: ScheduleGridCustomPaint(
          fromHour,
          toHour,
          timeLabelsWidth,
          dateLabelsHeight,
          columns,
        ));
}

class ScheduleGridCustomPaint extends CustomPainter {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;
  final double dateLabelsHeight;
  final int columns;

  ScheduleGridCustomPaint(
    this.fromHour,
    this.toHour,
    this.timeLabelsWidth,
    this.dateLabelsHeight,
    this.columns,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final secondaryPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    var lines = toHour - fromHour;

    drawHorizontalLines(lines, size, canvas, secondaryPaint);
    drawVerticalLines(size, canvas, secondaryPaint);
  }

  void drawHorizontalLines(
      int lines, Size size, Canvas canvas, Paint secondaryPaint) {
    //canvas.drawLine(Offset(0, 0), Offset(size.width, 0), secondaryPaint);

    for (var i = 0; i < lines; i++) {
      var y = ((size.height - dateLabelsHeight) / lines) * i + dateLabelsHeight;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), secondaryPaint);
    }
  }

  void drawVerticalLines(Size size, Canvas canvas, Paint secondaryPaint) {
    for (var i = 0; i < columns; i++) {
      var x = ((size.width - timeLabelsWidth) / columns) * i + timeLabelsWidth;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), secondaryPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
