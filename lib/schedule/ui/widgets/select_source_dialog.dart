import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_source_type.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/enter_dualis_credentials_dialog.dart';
import 'package:dhbwstudentapp/schedule/ui/widgets/enter_rapla_url_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart';

class SelectSourceDialog {
  final PreferencesProvider _preferencesProvider;
  final ScheduleSourceProvider _scheduleSourceProvider;

  ScheduleSourceType _currentScheduleSource;

  SelectSourceDialog(this._preferencesProvider, this._scheduleSourceProvider);

  Future show(BuildContext context) async {
    var type = await _preferencesProvider.getScheduleSourceType();
    _currentScheduleSource = ScheduleSourceType.values[type];

    await showDialog(
      context: context,
      builder: (context) => _buildDialog(context),
    );
  }

  SimpleDialog _buildDialog(BuildContext context) {
    return SimpleDialog(
      title: Text(L.of(context).onboardingScheduleSourceTitle),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Text(
            L.of(context).onboardingScheduleSourceDescription,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        RadioListTile(
          groupValue: _currentScheduleSource,
          value: ScheduleSourceType.Rapla,
          onChanged: (v) => sourceSelected(v, context),
          title: Text(L.of(context).scheduleSourceTypeRapla),
        ),
        RadioListTile(
          groupValue: _currentScheduleSource,
          value: ScheduleSourceType.Dualis,
          onChanged: (v) => sourceSelected(v, context),
          title: Text(L.of(context).scheduleSourceTypeDualis),
        ),
        RadioListTile(
          groupValue: _currentScheduleSource,
          value: ScheduleSourceType.Ical,
          onChanged: (v) => sourceSelected(v, context),
          title: Text("Ical"),
        ),
        RadioListTile(
          groupValue: _currentScheduleSource,
          value: ScheduleSourceType.None,
          onChanged: (v) => sourceSelected(v, context),
          title: Text(L.of(context).scheduleSourceTypeNone),
        )
      ],
    );
  }

  Future<void> sourceSelected(
      ScheduleSourceType type, BuildContext context) async {
    _preferencesProvider.setScheduleSourceType(type.index);

    Navigator.of(context).pop();

    switch (type) {
      case ScheduleSourceType.None:
        await _scheduleSourceProvider.setupScheduleSource();
        break;
      case ScheduleSourceType.Rapla:
        await EnterRaplaUrlDialog(
          _preferencesProvider,
          KiwiContainer().resolve(),
        ).show(context);
        break;
      case ScheduleSourceType.Dualis:
        await EnterDualisCredentialsDialog(
          _preferencesProvider,
          KiwiContainer().resolve(),
        ).show(context);
        break;
      case ScheduleSourceType.Ical:
        await _scheduleSourceProvider.setupScheduleSource();
        break;
    }
  }
}
