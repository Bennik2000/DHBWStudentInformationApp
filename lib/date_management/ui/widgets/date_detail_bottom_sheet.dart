import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/colors.dart';
import 'package:dhbwstudentapp/common/util/date_utils.dart';
import 'package:dhbwstudentapp/date_management/model/date_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDetailBottomSheet extends StatelessWidget {
  final DateEntry? dateEntry;

  const DateDetailBottomSheet({Key? key, this.dateEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMd(L.of(context).locale.languageCode)
        .format(dateEntry!.start);
    final time = DateFormat.Hm(L.of(context).locale.languageCode)
        .format(dateEntry!.start);

    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Center(
                child: Container(
                  height: 8,
                  width: 30,
                  decoration: BoxDecoration(
                      color: colorSeparator(),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      dateEntry!.description,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          date,
                          softWrap: true,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        if (isAtMidnight(dateEntry!.start)) Container() else Text(
                                time,
                                softWrap: true,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                dateEntry!.comment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
