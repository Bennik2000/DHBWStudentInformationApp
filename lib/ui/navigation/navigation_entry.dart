import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class NavigationEntry<T extends BaseViewModel> {
  T? _viewModel;

  String get route;

  String title(BuildContext context);

  Icon get icon;

  Widget buildRoute(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: build(context),
    );
  }

  Widget build(BuildContext context);

  T get model {
    return _viewModel ??= initViewModel();
  }

  T initViewModel();

  // TODO: [Leptopoda] clean up but not null related so something for later
  List<Widget> appBarActions(BuildContext context);
}
