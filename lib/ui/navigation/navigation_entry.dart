import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class NavigationEntry {
  BaseViewModel _viewModel;

  String get route;

  String title(BuildContext context);

  Widget icon(BuildContext context);

  Widget buildRoute(BuildContext context) {
    var model = viewModel();
    if (model != null) {
      return ChangeNotifierProvider.value(
        value: model,
        child: build(context),
      );
    } else {
      return build(context);
    }
  }

  Widget build(BuildContext context);

  BaseViewModel viewModel() {
    if (_viewModel == null) {
      _viewModel = initViewModel();
    }

    return _viewModel;
  }

  BaseViewModel initViewModel() => null;

  List<Widget> appBarActions(BuildContext context) => [];
}
