import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/root_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      content: PropertyChangeProvider<RootViewModel>(
        value: _rootViewModel,
        child: PropertyChangeConsumer(
          properties: const [
            "isDarkMode",
          ],
          builder: (BuildContext context, RootViewModel model, Set properties) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: Text(L.of(context).selectThemeLight),
                  value: false,
                  groupValue: _rootViewModel.isDarkMode,
                  onChanged: (v) => _rootViewModel.setIsDarkMode(v),
                ),
                RadioListTile(
                  title: Text(L.of(context).selectThemeDark),
                  value: true,
                  groupValue: _rootViewModel.isDarkMode,
                  onChanged: (v) => _rootViewModel.setIsDarkMode(v),
                ),
                RadioListTile(
                  title: Text(L.of(context).selectThemeSystem),
                  value: null,
                  groupValue: _rootViewModel.isDarkMode,
                  onChanged: (v) => _rootViewModel.setIsDarkMode(v),
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
