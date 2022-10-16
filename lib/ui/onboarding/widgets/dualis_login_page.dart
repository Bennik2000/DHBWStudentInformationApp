import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/dualis/model/credentials.dart';
import 'package:dhbwstudentapp/ui/login_credentials_widget.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/dualis_login_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

///
/// Widget which provides a username and password text field to input login
/// credentials.
///
class DualisLoginCredentialsPage extends StatefulWidget {
  const DualisLoginCredentialsPage({super.key});

  @override
  State<DualisLoginCredentialsPage> createState() =>
      _DualisLoginCredentialsPageState();
}

class _DualisLoginCredentialsPageState
    extends State<DualisLoginCredentialsPage> {
  final CredentialsEditingController controller =
      CredentialsEditingController();

  _DualisLoginCredentialsPageState();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<OnboardingStepViewModel, String>(
      builder: (
        BuildContext context,
        OnboardingStepViewModel? base,
        Set<Object>? _,
      ) {
        final viewModel = base as DualisLoginViewModel?;

        final credentials = viewModel?.credentials;

        if (credentials != null) {
          controller.credentials = credentials;
        }

        final widgets = <Widget>[];

        widgets.addAll(_buildHeader());
        widgets.add(
          LoginCredentialsWidget(
            controller: controller,
            onSubmitted: () async {
              await _testCredentials(viewModel);
            },
          ),
        );
        widgets.add(_buildTestCredentialsButton(viewModel));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widgets,
        );
      },
    );
  }

  Widget _buildTestCredentialsButton(DualisLoginViewModel? viewModel) {
    return Expanded(
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 16, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: viewModel?.isValid == false
                    ? Text(
                        L.of(context).onboardingDualisWrongCredentials,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Theme.of(context).errorColor),
                      )
                    : Container(),
              ),
              if (viewModel?.isLoading ?? false)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                )
              else
                viewModel?.loginSuccess ?? false
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : TextButton(
                        onPressed: () async {
                          await _testCredentials(viewModel);
                        },
                        child: Text(
                          L
                              .of(context)
                              .onboardingDualisTestButton
                              .toUpperCase(),
                        ),
                      ),
            ],
          ),
        ),
      ),
    );
  }

  Future _testCredentials(DualisLoginViewModel? viewModel) async {
    if (viewModel == null) return;

    await viewModel.testCredentials(controller.credentials);
  }

  List<Widget> _buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: Center(
          child: Text(
            L.of(context).onboardingDualisPageTitle,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Divider(),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Text(
          L.of(context).onboardingDualisPageDescription,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.justify,
        ),
      ),
    ];
  }
}
