import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/material.dart';

///
/// Provides a base class for a simple help dialog with title and content.
/// Deriving classes only need to implement the title() and content() methods
///
abstract class HelpDialog {
  Future show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: dialogBuilder,
    );
  }

  Widget dialogBuilder(BuildContext context) {
    return AlertDialog(
      title: Text(title(context)),
      content: Text(
        content(context),
        style: Theme.of(context).textTheme.bodyText2,
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

  String title(BuildContext context);

  String content(BuildContext context);
}
