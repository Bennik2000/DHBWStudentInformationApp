import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle textStyleDailyScheduleEntryWidgetProfessor(BuildContext context) =>
    Theme.of(context).textTheme.subtitle2;

TextStyle textStyleDailyScheduleEntryWidgetTitle(BuildContext context) =>
    Theme.of(context)
        .textTheme
        .headline4
        .copyWith(color: Theme.of(context).textTheme.headline6.color);

TextStyle textStyleDailyScheduleEntryWidgetType(BuildContext context) =>
    Theme.of(context).textTheme.bodyText2.copyWith(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.15,
        );

TextStyle textStyleDailyScheduleEntryWidgetTimeStart(BuildContext context) =>
    Theme.of(context).textTheme.headline5.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        );

TextStyle textStyleDailyScheduleEntryWidgetTimeEnd(BuildContext context) =>
    Theme.of(context).textTheme.subtitle2;

TextStyle textStyleDailyScheduleCurrentDate(BuildContext context) =>
    Theme.of(context).textTheme.headline4.copyWith(
          color: Theme.of(context).textTheme.headline5.color,
        );
TextStyle textStyleDailyScheduleNoEntries(BuildContext context) =>
    Theme.of(context).textTheme.headline5;

TextStyle textStyleScheduleEntryWidgetTitle(BuildContext context) =>
    Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.normal,
        );

TextStyle textStyleScheduleEntryBottomPageTitle(BuildContext context) =>
    Theme.of(context).textTheme.subtitle2;

TextStyle textStyleScheduleEntryBottomPageTimeFromTo(BuildContext context) =>
    Theme.of(context).textTheme.caption;

TextStyle textStyleScheduleEntryBottomPageTime(BuildContext context) =>
    Theme.of(context).textTheme.headline5;

TextStyle textStyleScheduleEntryBottomPageType(BuildContext context) =>
    Theme.of(context).textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.w300,
        );

TextStyle textStyleScheduleWidgetColumnTitleDay(BuildContext context) =>
    Theme.of(context).textTheme.subtitle2.copyWith(
          fontWeight: FontWeight.w300,
        );

TextStyle textStyleUpdateNoConnection(BuildContext context) =>
    Theme.of(context).textTheme.subtitle2.copyWith(
          color: colorNoConnectionForeground(),
        );
