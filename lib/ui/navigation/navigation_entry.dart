import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:flutter/material.dart';

abstract class NavigationEntry {
  Key get key;

  BaseViewModel _viewModel;

  String title(BuildContext context);

  Widget icon(BuildContext context);

  BaseViewModel viewModel() {
    if (_viewModel == null) {
      _viewModel = initViewModel();
    }

    return _viewModel;
  }

  BaseViewModel initViewModel() => null;

  List<Widget> appBarActions(BuildContext context) => [];
}
