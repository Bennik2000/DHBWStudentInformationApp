import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulInformationPage extends StatelessWidget {
  const UsefulInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(L.of(context).informationPageDHBWHomepage),
            onTap: () {
              openLink("https://www.dhbw-stuttgart.de/home/");
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_usage),
            title: Text(L.of(context).informationPageDualis),
            onTap: () {
              openLink("https://dualis.dhbw.de/");
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(L.of(context).informationPageRoundcube),
            onTap: () {
              openLink(
                "https://lehre-webmail.dhbw-stuttgart.de/roundcubemail/",
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.room_service),
            title: Text(L.of(context).informationPageMoodle),
            onTap: () {
              openLink("http://elearning.dhbw-stuttgart.de/");
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(L.of(context).informationPageLocation),
            onTap: () {
              openLink(
                "https://www.dhbw-stuttgart.de/themen/hochschule/standorte/",
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.wifi),
            title: Text(L.of(context).informationPageEduroam),
            onTap: () {
              openLink(
                "https://www.dhbw-stuttgart.de/themen/einrichtungen/itservice-center/informationen-fuer-studierende/wlan-vpn-zugang/",
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(L.of(context).informationPageStuV),
            onTap: () {
              openLink("https://stuv-stuttgart.de/");
            },
          ),
          ListTile(
            leading: const Icon(Icons.pool),
            title: Text(L.of(context).informationPageDHBWSports),
            onTap: () {
              openLink(
                "https://www.dhbw-stuttgart.de/themen/einrichtungen/hochschulsport/",
              );
            },
          ),
        ],
      ),
    );
  }

  void openLink(String url) {
    launchUrl(Uri.parse(url));
  }
}
