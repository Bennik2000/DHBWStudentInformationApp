import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleGrid extends CustomPaint {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;
  final double dateLabelsHeight;
  final int columns;
  final Color gridLinesColor;

  ScheduleGrid(
    this.fromHour,
    this.toHour,
    this.timeLabelsWidth,
    this.dateLabelsHeight,
    this.columns,
    this.gridLinesColor,
  ) : super(
            painter: ScheduleGridCustomPaint(
          fromHour,
          toHour,
          timeLabelsWidth,
          dateLabelsHeight,
          columns,
          gridLinesColor,
        ));
}

class ScheduleGridCustomPaint extends CustomPainter {
  final int fromHour;
  final int toHour;
  final double timeLabelsWidth;
  final double dateLabelsHeight;
  final int columns;
  final Color gridLineColor;

  ScheduleGridCustomPaint(
    this.fromHour,
    this.toHour,
    this.timeLabelsWidth,
    this.dateLabelsHeight,
    this.columns,
    this.gridLineColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final secondaryPaint = Paint()
      ..color = gridLineColor
      ..strokeWidth = 1;

    var lines = toHour - fromHour;

    drawHorizontalLines(lines, size, canvas, secondaryPaint);
    drawVerticalLines(size, canvas, secondaryPaint);
  }

  void drawHorizontalLines(
    int lines,
    Size size,
    Canvas canvas,
    Paint secondaryPaint,
  ) {
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
