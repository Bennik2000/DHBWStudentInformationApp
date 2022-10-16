import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/custom_icons_icons.dart';
import 'package:dhbwstudentapp/dualis/ui/dualis_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/dualis_help_dialog.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DualisNavigationEntry extends NavigationEntry<StudyGradesViewModel> {
  DualisNavigationEntry();

  @override
  Icon icon = const Icon(Icons.data_usage);

  @override
  String title(BuildContext context) {
    return L.of(context).screenDualisTitle;
  }

  @override
  StudyGradesViewModel initViewModel() {
    return StudyGradesViewModel(
      KiwiContainer().resolve(),
      KiwiContainer().resolve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DualisPage();
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    return [
      PropertyChangeProvider<StudyGradesViewModel, Object>(
        value: model,
        child: PropertyChangeConsumer(
          builder:
              (BuildContext _, StudyGradesViewModel? __, Set<Object>? ___) =>
                  model.loginState != LoginState.LoggedIn
                      ? IconButton(
                          icon: const Icon(Icons.help_outline),
                          onPressed: () async {
                            await const DualisHelpDialog().show(context);
                          },
                          tooltip: L.of(context).helpButtonTooltip,
                        )
                      : IconButton(
                          icon: const Icon(CustomIcons.logout),
                          onPressed: () async {
                            await model.logout();
                          },
                          tooltip: L.of(context).logoutButtonTooltip,
                        ),
        ),
      ),
    ];
  }

  @override
  String get route => "dualis";
}
