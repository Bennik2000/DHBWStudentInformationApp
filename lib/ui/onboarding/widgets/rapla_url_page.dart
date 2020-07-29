import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_rapla_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class RaplaUrlPage extends StatefulWidget {
  @override
  _RaplaUrlPageState createState() => _RaplaUrlPageState();
}

class _RaplaUrlPageState extends State<RaplaUrlPage> {
  final TextEditingController _urlTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Center(
            child: Text(
              "Jetzt brauche ich den Link zu Rapla",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Divider(),
        ),
        Text(
          "Hier musst Du den Link zum Rapla Vorlesungsplan eingeben. Diesen bekommst Du üblicherweise am Anfang des Semesters aus dem Sekretariat.",
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
          child: PropertyChangeConsumer(
            builder: (BuildContext context, OnboardingViewModelBase model,
                Set<Object> _) {
              var viewModel = model as OnboardingRaplaViewModel;

              if (_urlTextController.text != viewModel.raplaUrl)
                _urlTextController.text = viewModel.raplaUrl;

              return Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _urlTextController,
                      decoration: InputDecoration(
                          errorText: (viewModel.urlHasError ?? false)
                              ? L.of(context).onboardingSourceUrlInvalid
                              : null,
                          hintText: L.of(context).onboardingSourceUrlHint),
                      onChanged: (value) {
                        viewModel.setRaplaUrl(value);
                      },
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () async {
                      await viewModel.pasteUrl();
                    },
                    icon: Icon(Icons.content_paste),
                    label: Text(
                      L.of(context).onboardingSourceUrlPaste.toUpperCase(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
