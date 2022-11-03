import 'package:dhbwstudentapp/common/data/preferences/app_theme_enum.dart';
import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

///
/// Shows a dialog to select dark/light or system theme as app theme
///
class SelectThemeDialog {
  final RootViewModel _rootViewModel;

  SelectThemeDialog(this._rootViewModel);

  Future show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: dialogBuilder,
    );
  }

  Widget dialogBuilder(BuildContext context) {
    return AlertDialog(
      title: Text(L.of(context).selectThemeDialogTitle),
      content: PropertyChangeProvider<RootViewModel, String>(
        value: _rootViewModel,
        child: PropertyChangeConsumer(
          properties: const [
            "appTheme",
          ],
          builder:
              (BuildContext context, RootViewModel? model, Set? properties) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<AppTheme>(
                  title: Text(L.of(context).selectThemeLight),
                  value: AppTheme.Light,
                  groupValue: _rootViewModel.appTheme,
                  onChanged: _rootViewModel.setAppTheme,
                ),
                RadioListTile<AppTheme>(
                  title: Text(L.of(context).selectThemeDark),
                  value: AppTheme.Dark,
                  groupValue: _rootViewModel.appTheme,
                  onChanged: _rootViewModel.setAppTheme,
                ),
                RadioListTile<AppTheme>(
                  title: Text(L.of(context).selectThemeSystem),
                  value: AppTheme.System,
                  groupValue: _rootViewModel.appTheme,
                  onChanged: _rootViewModel.setAppTheme,
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text(L.of(context).dialogOk.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
