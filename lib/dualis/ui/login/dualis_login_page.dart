import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/viewmodels/study_grades_view_model.dart';
import 'package:dhbwstudentapp/dualis/ui/widgets/login_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DualisLoginPage extends StatelessWidget {
  final WidgetBuilder builder;

  const DualisLoginPage({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StudyGradesViewModel viewModel = Provider.of<BaseViewModel>(context);

    return AnimatedSwitcher(
      child: viewModel.isLoggedIn
          ? builder(context)
          : buildLoginPage(context, viewModel),
      duration: Duration(milliseconds: 200),
    );
  }

  Widget buildLoginPage(BuildContext context, StudyGradesViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32),
          child: LoginForm(
            loginFailedText: L.of(context).dualisLoginFailed,
            title: Text(
              L.of(context).dualisLogin,
              style: Theme.of(context).textTheme.title,
            ),
            onLogin: model.login,
          ),
        ),
      ],
    );
  }
}
