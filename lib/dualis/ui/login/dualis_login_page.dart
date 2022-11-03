import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/login_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DualisLoginPage extends StatelessWidget {
  const DualisLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StudyGradesViewModel model =
        Provider.of<StudyGradesViewModel>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: LoginForm(
                loginFailedText: L.of(context).dualisLoginFailed,
                title: Text(
                  L.of(context).dualisLogin,
                  style: Theme.of(context).textTheme.headline6,
                ),
                onLogin: model.login,
                onLoadCredentials: model.loadCredentials,
                onSaveCredentials: model.saveCredentials,
                onClearCredentials: model.clearCredentials,
                getDoSaveCredentials: model.getDoSaveCredentials,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
