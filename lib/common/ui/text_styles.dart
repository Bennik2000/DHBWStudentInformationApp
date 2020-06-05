import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle textStyleDailyScheduleEntryWidgetProfessor(BuildContext context) =>
    Theme.of(context).textTheme.subtitle;

TextStyle textStyleDailyScheduleEntryWidgetTitle(BuildContext context) =>
    Theme.of(context)
        .textTheme
        .display1
        .copyWith(color: Theme.of(context).textTheme.title.color);

TextStyle textStyleDailyScheduleEntryWidgetType(BuildContext context) =>
    Theme.of(context).textTheme.body1.copyWith(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.15,
        );

TextStyle textStyleDailyScheduleEntryWidgetTimeStart(BuildContext context) =>
    Theme.of(context).textTheme.headline.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        );

TextStyle textStyleDailyScheduleEntryWidgetTimeEnd(BuildContext context) =>
    Theme.of(context).textTheme.subtitle;

TextStyle textStyleDailyScheduleCurrentDate(BuildContext context) =>
    Theme.of(context).textTheme.display2;

TextStyle textStyleScheduleEntryWidgetTitle(BuildContext context) =>
    Theme.of(context).textTheme.body2.copyWith(
          fontWeight: FontWeight.normal,
        );

TextStyle textStyleScheduleEntryBottomPageTitle(BuildContext context) =>
    Theme.of(context).textTheme.subtitle;

TextStyle textStyleScheduleEntryBottomPageTimeFromTo(BuildContext context) =>
    Theme.of(context).textTheme.caption;

TextStyle textStyleScheduleEntryBottomPageTime(BuildContext context) =>
    Theme.of(context).textTheme.headline;

TextStyle textStyleScheduleEntryBottomPageType(BuildContext context) =>
    Theme.of(context).textTheme.body2.copyWith(
          fontWeight: FontWeight.w300,
        );

TextStyle textStyleScheduleWidgetColumnTitleDay(BuildContext context) =>
    Theme.of(context).textTheme.subtitle.copyWith(
          fontWeight: FontWeight.w300,
        );

TextStyle textStyleUpdateNoConnection(BuildContext context) =>
    Theme.of(context).textTheme.subtitle.copyWith(
          color: colorNoConnectionForeground(),
        );
