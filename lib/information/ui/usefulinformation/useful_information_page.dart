import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.language),
          title: Text("Homepage der DHBW"),
          onTap: () {
            openLink("https://www.dhbw-stuttgart.de/home/");
          },
        ),
        ListTile(
          leading: Icon(Icons.data_usage),
          title: Text("Dualis"),
          onTap: () {
            openLink("https://dualis.dhbw.de/");
          },
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text("Roundcube Web Email"),
          onTap: () {
            openLink("https://lehre-webmail.dhbw-stuttgart.de/roundcubemail/");
          },
        ),
        ListTile(
          leading: Icon(Icons.room_service),
          title: Text("Moodle"),
          onTap: () {
            openLink("http://elearning.dhbw-stuttgart.de/");
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text("Lage der Standorte"),
          onTap: () {
            openLink(
                "https://www.dhbw-stuttgart.de/themen/hochschule/standorte/");
          },
        ),
        ListTile(
          leading: Icon(Icons.wifi),
          title: Text("eduroam"),
          onTap: () {
            openLink(
                "https://www.dhbw-stuttgart.de/themen/einrichtungen/itservice-center/informationen-fuer-studierende/wlan-vpn-zugang/");
          },
        ),
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text("StuV"),
          onTap: () {
            openLink("https://stuv-stuttgart.de/");
          },
        ),
        ListTile(
          leading: Icon(Icons.pool),
          title: Text("Hochschulsport"),
          onTap: () {
            openLink(
                "https://www.dhbw-stuttgart.de/themen/einrichtungen/hochschulsport/");
          },
        ),
      ],
    );
  }

  void openLink(String url) {
    launch(url);
  }
}
