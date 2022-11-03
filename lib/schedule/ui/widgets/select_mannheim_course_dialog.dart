import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/mannheim_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:dhbwstudentapp/ui/onboarding/widgets/mannheim_page.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SelectMannheimCourseDialog {
  final ScheduleSourceProvider _scheduleSourceProvider;

  late MannheimViewModel _mannheimViewModel;

  SelectMannheimCourseDialog(
    this._scheduleSourceProvider,
  );

  Future show(BuildContext context) async {
    _mannheimViewModel = MannheimViewModel(_scheduleSourceProvider);

    await showDialog(
      context: context,
      builder: (context) => _buildDialog(context),
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text(L.of(context).onboardingMannheimTitle),
      contentPadding: EdgeInsets.zero,
      content: PropertyChangeProvider<OnboardingStepViewModel, String>(
        value: _mannheimViewModel,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Text(
                  L.of(context).onboardingMannheimDescription,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: SelectMannheimCourseWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: _buildButtons(context),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return <Widget>[
      TextButton(
        child: Text(L.of(context).dialogOk.toUpperCase()),
        onPressed: () async {
          await _mannheimViewModel.save();
          Navigator.of(context).pop();
        },
      ),
    ];
  }
}
