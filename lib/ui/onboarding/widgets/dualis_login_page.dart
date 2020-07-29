import 'package:dhbwstudentapp/ui/login_credentials_widget.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_dualis_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DualisLoginCredentialsPage extends StatefulWidget {
  @override
  _DualisLoginCredentialsPageState createState() =>
      _DualisLoginCredentialsPageState();
}

class _DualisLoginCredentialsPageState
    extends State<DualisLoginCredentialsPage> {
  TextEditingController _usernameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer(
      builder:
          (BuildContext context, OnboardingViewModelBase base, Set<Object> _) {
        var viewModel = base as OnboardingDualisViewModel;

        if (_usernameEditingController.text != viewModel.username) {
          _usernameEditingController.text = viewModel.username;
        }
        if (_passwordEditingController.text != viewModel.password) {
          _passwordEditingController.text = viewModel.password;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Center(
                child: Text(
                  "Dualis Login",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text(
                "Hier kannst du Deine Dualis Zugangsdaten eingeben, um deine Noten in der App abzurufen. Dieser Schritt ist optinal und kann auch zu einem späteren Zeitpunkt durchgeführt werden",
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.justify,
              ),
            ),
            LoginCredentialsWidget(
              usernameEditingController: _usernameEditingController,
              passwordEditingController: _passwordEditingController,
              onSubmitted: () async {
                await testCredentials(viewModel);
              },
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  viewModel.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Container(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16),
                          child: viewModel.loginSuccess
                              ? Container()
                              : FlatButton(
                                  onPressed: () async {
                                    await testCredentials(viewModel);
                                  },
                                  child: Text("Testen".toUpperCase()),
                                  textColor: viewModel.loginSuccess
                                      ? Colors.green
                                      : Colors.red,
                                ),
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future testCredentials(OnboardingDualisViewModel viewModel) async {
    await viewModel.testCredentials(
      _usernameEditingController.text,
      _passwordEditingController.text,
    );
  }
}
