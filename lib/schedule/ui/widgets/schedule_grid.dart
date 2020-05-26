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
      ..color = Colors.black12
      ..strokeWidth = 1;

    for (var i = fromHour; i < toHour; i++) {
      var y = (size.height / (toHour - fromHour)) * ((i - fromHour) + 1);

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    canvas.drawLine(Offset(timeLabelsWidth, 0),
        Offset(timeLabelsWidth, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
