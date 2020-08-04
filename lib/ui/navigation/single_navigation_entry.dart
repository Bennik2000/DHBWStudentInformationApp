import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/ui/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';

abstract class SingleNavigationEntry extends NavigationEntry {
  Widget build(BuildContext context);
}

class FixedSingleNavigationEntry extends SingleNavigationEntry {
  final WidgetBuilder builder;
  final WidgetBuilder iconBuilder;
  final String Function(BuildContext) titleBuilder;
  final BaseViewModel Function() viewModelBuilder;

  final Key pageKey;

  FixedSingleNavigationEntry({
    this.builder,
    this.iconBuilder,
    this.titleBuilder,
    this.pageKey,
    this.viewModelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  @override
  Widget icon(BuildContext context) {
    return iconBuilder(context);
  }

  @override
  Key get key => pageKey;

  @override
  String title(BuildContext context) {
    return titleBuilder(context);
  }

  @override
  BaseViewModel initViewModel() {
    if (viewModelBuilder != null) {
      return viewModelBuilder();
    }

    return null;
  }
}
