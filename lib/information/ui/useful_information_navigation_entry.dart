import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/information/ui/usefulinformation/useful_information_page.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';

class UsefulInformationNavigationEntry extends NavigationEntry<BaseViewModel> {
  UsefulInformationNavigationEntry();

  @override
  Widget build(BuildContext context) {
    return const UsefulInformationPage();
  }

  @override
  Icon icon = const Icon(Icons.info_outline);

  @override
  String title(BuildContext context) {
    return L.of(context).screenUsefulLinks;
  }

  @override
  String get route => "usefulInformation";

  @override
  BaseViewModel initViewModel() => BaseViewModel();

  @override
  List<Widget> appBarActions(BuildContext context) => [];
}
