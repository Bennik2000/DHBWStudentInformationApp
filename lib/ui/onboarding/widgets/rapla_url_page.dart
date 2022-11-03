import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/rapla_url_view_model.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class RaplaUrlPage extends StatelessWidget {
  const RaplaUrlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlTextController = TextEditingController();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Center(
            child: Text(
              L.of(context).onboardingRaplaPageTitle,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Divider(),
        ),
        Text(
          L.of(context).onboardingRaplaPageDescription,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: PropertyChangeConsumer<OnboardingStepViewModel, String>(
              builder: (
                BuildContext context,
                OnboardingStepViewModel? model,
                Set<Object>? _,
              ) {
                final viewModel = model as RaplaUrlViewModel?;

                if (viewModel?.raplaUrl != null &&
                    urlTextController.text != viewModel!.raplaUrl) {
                  urlTextController.text = viewModel.raplaUrl!;
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: urlTextController,
                          decoration: InputDecoration(
                            errorText: viewModel?.urlHasError == true
                                ? L.of(context).onboardingRaplaUrlInvalid
                                : null,
                            hintText: L.of(context).onboardingRaplaUrlHint,
                          ),
                          onChanged: viewModel?.setRaplaUrl,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await viewModel?.pasteUrl();
                        },
                        icon: const Icon(Icons.content_paste),
                        label: Text(
                          L.of(context).onboardingRaplaUrlPaste.toUpperCase(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
