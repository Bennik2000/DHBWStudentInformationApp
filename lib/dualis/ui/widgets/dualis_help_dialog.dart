import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/widgets/help_dialog.dart';
import 'package:flutter/material.dart';

class DualisHelpDialog extends HelpDialog {
  const DualisHelpDialog();

  @override
  String content(BuildContext context) {
    return L.of(context).dualisHelpDialogContent;
  }

  @override
  String title(BuildContext context) {
    return L.of(context).dualisHelpDialogTitle;
  }
}
