import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/select_source_onboarding_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SelectAppFeaturesWidget extends StatelessWidget {
  const SelectAppFeaturesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer(
      builder: (
        BuildContext context,
        OnboardingStepViewModel model,
        Set<Object> _,
      ) {
        var viewModel = model as SelectSourceOnboardingViewModel;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Center(
                child: Text(
                  "Vorlesungsplan",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Text("Woher soll der Vorlesungsplan abgerufen werden?"),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Divider(),
            ),
            RadioListTile(
              value: ScheduleSourceType.Rapla, //model.useRapla,
              onChanged: viewModel.setScheduleSourceType, // model.setUseRapla,
              title: Text(
                "Rapla",
              ),
              groupValue: viewModel.scheduleSourceType,
            ),
            RadioListTile(
              value: ScheduleSourceType.Dualis, //model.useDualis,
              onChanged: viewModel.setScheduleSourceType,
              title: Text(
                "Dualis",
              ),
              groupValue: viewModel.scheduleSourceType,
            ),
            RadioListTile(
              value: ScheduleSourceType.None, //model.useDualis,
              onChanged: viewModel.setScheduleSourceType,
              title: Text(
                "Keinen Vorlesungsplan",
              ),
              groupValue: viewModel.scheduleSourceType,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Text(
                L.of(context).disclaimer,
                style: Theme.of(context).textTheme.overline,
              ),
            ),
          ],
        );
      },
    );
  }
}
