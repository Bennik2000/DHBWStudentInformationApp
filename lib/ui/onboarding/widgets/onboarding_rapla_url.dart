import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          "Zuerst musst Du den Link zum Rapla Vorlesungsplan eingeben. Diesen bekommst Du üblicherweise am Anfang des Semesters aus dem Sekretariat.",
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
          child: TextField(
            controller: _urlTextController,
            decoration: InputDecoration(
                errorText:
                    true ? L.of(context).onboardingSourceUrlInvalid : null,
                hintText: L.of(context).onboardingSourceUrlHint),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
