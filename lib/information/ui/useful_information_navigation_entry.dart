import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/information/ui/usefulinformation/useful_information_page.dart';
import 'package:dhbwstudentapp/ui/navigation/single_navigation_entry.dart';
import 'package:flutter/material.dart';

class UsefulInformationNavigationEntry extends SingleNavigationEntry {
  @override
  Widget build(BuildContext context) {
    return UsefulInformationPage();
  }

  @override
  Widget icon(BuildContext context) {
    return Icon(Icons.info_outline);
  }

  @override
  Key get key => ValueKey("UsefulInformationNavigationEntry");

  @override
  String title(BuildContext context) {
    return L.of(context).screenUsefulLinks;
  }
}
