import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SelectAppFeaturesWidget extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const SelectAppFeaturesWidget({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Center(
            child: Text(
              L.of(context).onboardingFunctionSwitchTitle,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Divider(),
        ),
        PropertyChangeConsumer(
          builder: (BuildContext context, OnboardingViewModel model, _) =>
              CheckboxListTile(
            value: model.useRapla,
            onChanged: model.setUseRapla,
            title: Text(
              L.of(context).onboardingFunctionSwitchRapla,
            ),
          ),
        ),
        PropertyChangeConsumer(
          builder: (BuildContext context, OnboardingViewModel model, _) =>
              CheckboxListTile(
            value: model.useDualis,
            onChanged: model.setUseDualis,
            title: Text(
              L.of(context).onboardingFunctionSwitchDualis,
            ),
          ),
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
  }
}
