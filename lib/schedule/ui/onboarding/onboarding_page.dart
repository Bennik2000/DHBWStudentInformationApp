import 'package:dhbwstuttgart/common/math/math.dart';
import 'package:dhbwstuttgart/schedule/ui/main_page.dart';
import 'package:dhbwstuttgart/schedule/ui/onboarding/viewmodels/onboarding_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _urlTextController = new TextEditingController();

  OnboardingViewModel viewModel;

  @override
  void initState() {
    viewModel = new OnboardingViewModel(kiwi.Container().resolve());
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Transform.translate(
              child: Transform.rotate(
                child: Container(
                  width: 2000,
                  height: 2000,
                  color: Theme.of(context).primaryColor,
                ),
                angle: toRadian(60),
              ),
              offset: Offset(-170, -450),
            ),
            Transform.translate(
              child: Transform.rotate(
                child: Container(
                  width: 2000,
                  height: 2000,
                  color: Theme.of(context).accentColor,
                ),
                angle: toRadian(55),
              ),
              offset: Offset(-200, -450),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Gleich gehts los!",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Divider(),
                  ),
                  Text(
                    "Zuerst musst Du den Link zum Vorlesungsplan eingeben.",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: PropertyChangeConsumer(
                      properties: ["raplaUrl", "urlHasError"],
                      builder: (BuildContext context, OnboardingViewModel model,
                          Set properties) {
                        if (_urlTextController.text != model.raplaUrl)
                          _urlTextController.text = model.raplaUrl;

                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _urlTextController,
                                decoration: InputDecoration(
                                    errorText: model.urlHasError
                                        ? "Die eingegebene URL ist ungültig"
                                        : null,
                                    hintText:
                                        "https://rapla.dhbw-stuttgart.de/rapla?key=7tfKQX7jOZcKnAU"),
                                onChanged: (value) {
                                  model.setRaplaUrl(value);
                                },
                              ),
                            ),
                            FlatButton.icon(
                              onPressed: () async {
                                ClipboardData data =
                                    await Clipboard.getData('text/plain');

                                if (data.text != null)
                                  model.setRaplaUrl(data.text);
                              },
                              icon: Icon(Icons.content_paste),
                              label: Text("Einfügen".toUpperCase()),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      PropertyChangeConsumer(
                        properties: ["urlHasError"],
                        builder: (BuildContext context,
                                OnboardingViewModel model, Set properties) =>
                            RaisedButton.icon(
                          onPressed: (!model.urlHasError &&
                                  model.raplaUrl != null &&
                                  model.raplaUrl.length > 0)
                              ? () async {
                                  await model.finishOnboarding();

                                  await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainPage(),
                                    ),
                                  );
                                }
                              : null,
                          icon: Icon(Icons.chevron_right),
                          label: Text("Los gehts!"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      value: viewModel,
    );
  }
}
