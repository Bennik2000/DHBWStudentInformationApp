import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/custom_icons_icons.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/dualis_page.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/dualis_help_dialog.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DualisNavigationEntry extends NavigationEntry {
  StudyGradesViewModel _viewModel;

  @override
  Widget icon(BuildContext context) {
    return Icon(CustomIcons.dualis);
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenDualisTitle;
  }

  @override
  BaseViewModel initViewModel() {
    if (_viewModel == null) {
      _viewModel = StudyGradesViewModel(
        KiwiContainer().resolve(),
        KiwiContainer().resolve(),
      );
    }

    return _viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return DualisPage();
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    initViewModel();
    return [
      PropertyChangeProvider(
        value: _viewModel,
        child: PropertyChangeConsumer(
          builder: (BuildContext _, StudyGradesViewModel __, Set<Object> ___) =>
              _viewModel.loginState != LoginState.LoggedIn
                  ? IconButton(
                      icon: Icon(CustomIcons.help),
                      onPressed: () async {
                        await DualisHelpDialog().show(context);
                      },
                      tooltip: L.of(context).helpButtonTooltip,
                    )
                  : IconButton(
                      icon: const Icon(CustomIcons.logout),
                      onPressed: () async {
                        await _viewModel.logout();
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
