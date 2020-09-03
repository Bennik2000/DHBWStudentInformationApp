import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateManagementHelpDialog {
  Future show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: dialogBuilder,
    );
  }

  Widget dialogBuilder(BuildContext context) {
    return AlertDialog(
      title: Text("Terminverwaltung"),
      content: Text("Über die Terminverwaltung siehst Du alle Termine, die im Laufe Deines Studiums wichtig sind. "
          "Die Termine werden von https://it.dhbw-stuttgart.de/DHermine/ abgerufen und sind nur für die DHBW Stuttgart verfügbar."),
      actions: [
        FlatButton(
          textColor: Theme.of(context).accentColor,
          child: Text("OK"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
