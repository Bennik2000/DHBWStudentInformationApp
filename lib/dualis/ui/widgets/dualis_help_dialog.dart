import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DualisHelpDialog {
  Future show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: dialogBuilder,
    );
  }

  Widget dialogBuilder(BuildContext context) {
    return AlertDialog(
      title: Text("Dualis Login"),
      content: Text("Mit den Dualis Zugangsdaten kannst Du deine Prüfungsergebnisse "
          "und Kursnoten in der App ansehen. \n\nFalls Du dich nicht anmelden kannst, prüfe die Internetverbindung und Zugangsdaten."),
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
