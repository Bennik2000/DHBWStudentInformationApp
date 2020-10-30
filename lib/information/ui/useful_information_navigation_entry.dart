import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/custom_icons_icons.dart';
import 'package:dhbwstudentapp/information/ui/usefulinformation/useful_information_page.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';

class UsefulInformationNavigationEntry extends NavigationEntry {
  @override
  Widget build(BuildContext context) {
    return UsefulInformationPage();
  }

  @override
  Widget icon(BuildContext context) {
    return Icon(CustomIcons.info);
  }

  @override
  String title(BuildContext context) {
    return L.of(context).screenUsefulLinks;
  }

  @override
  String get route => "usefulInformation";
}
