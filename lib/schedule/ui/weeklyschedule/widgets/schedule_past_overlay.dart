import 'dart:math';

import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SchedulePastOverlay extends CustomPaint {
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime now;
  final int fromHour;
  final int toHour;
  final int columns;
  final Color overlayColor;

  SchedulePastOverlay(
    this.fromHour,
    this.toHour,
    this.overlayColor,
    this.fromDate,
    this.toDate,
    this.now,
    this.columns,
  ) : super(
          painter: SchedulePastOverlayCustomPaint(
            toStartOfDay(fromDate),
            tomorrow(toStartOfDay(toDate)),
            now,
            fromHour,
            toHour,
            columns,
            overlayColor,
          ),
        );
}

class SchedulePastOverlayCustomPaint extends CustomPainter {
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime now;
  final int fromHour;
  final int toHour;
  final int columns;
  final Color overlayColor;

  SchedulePastOverlayCustomPaint(
    this.fromDate,
    this.toDate,
    this.now,
    this.fromHour,
    this.toHour,
    this.columns,
    this.overlayColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = overlayColor
      ..strokeWidth = 1;

    if (now.isBefore(toDate) && now.isAfter(fromDate)) {
      drawPartialPastOverlay(canvas, size, overlayPaint);
    } else if (now.isAfter(toDate)) {
      drawCompletePastOverlay(canvas, size, overlayPaint);
    }
  }

  void drawCompletePastOverlay(Canvas canvas, Size size, Paint overlayPaint) {
    canvas.drawRect(
        Rect.fromLTRB(
          0,
          0,
          size.width,
          size.height,
        ),
        overlayPaint);
  }

  void drawPartialPastOverlay(Canvas canvas, Size size, Paint overlayPaint) {
    var difference = now.difference(fromDate);
    var differenceInDays = (difference.inHours / 24).floor();
    var dayWidth = size.width / columns;

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        dayWidth * differenceInDays,
        size.height,
      ),
      overlayPaint,
    );

    var leftoverMinutes =
        difference.inMinutes - (differenceInDays * 24 * 60) - (60 * fromHour);

    var displayedMinutes = (toHour - fromHour) * 60;
    var leftoverHeight = leftoverMinutes * (size.height / displayedMinutes);

    if (leftoverHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          dayWidth * differenceInDays,
          0,
          dayWidth,
          min(size.height, leftoverHeight),
        ),
        overlayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    return false;
  }
}
