import 'package:dhbwstudentapp/common/i18n/localizations.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/mannheim_view_model.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MannheimPage extends StatefulWidget {
  @override
  _MannheimPageState createState() => _MannheimPageState();
}

class _MannheimPageState extends State<MannheimPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Center(
            child: Text(
              L.of(context).onboardingMannheimTitle,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Divider(),
        ),
        Text(
          L.of(context).onboardingMannheimDescription,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: SelectMannheimCourseWidget(),
          ),
        ),
      ],
    );
  }
}

class SelectMannheimCourseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<OnboardingStepViewModel, String>(
      builder:
          (BuildContext context, OnboardingStepViewModel model, Set<Object> _) {
        var viewModel = model as MannheimViewModel;

        switch (viewModel.loadingState) {
          case LoadCoursesState.Loading:
            return _buildLoadingIndicator();
          case LoadCoursesState.Loaded:
            return _buildCourseList(context, viewModel);
          case LoadCoursesState.Failed:
            return _buildLoadingError(context, viewModel);
        }

        return Container();
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildCourseList(BuildContext context, MannheimViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: viewModel.courses?.length ?? 0,
        itemBuilder: (BuildContext context, int index) =>
            _buildCourseListTile(viewModel, index, context),
      ),
    );
  }

  ListTile _buildCourseListTile(
    MannheimViewModel viewModel,
    int index,
    BuildContext context,
  ) {
    var isSelected = viewModel.selectedCourse == viewModel.courses[index];

    return ListTile(
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.secondary,
            )
          : null,
      title: Text(
        viewModel.courses[index].name,
        style: isSelected
            ? TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              )
            : null,
      ),
      subtitle: Text(viewModel.courses[index].title),
      onTap: () => viewModel.setSelectedCourse(viewModel.courses[index]),
    );
  }

  Widget _buildLoadingError(BuildContext context, MannheimViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(L.of(context).onboardingMannheimLoadCoursesFailed),
          Padding(
            padding: const EdgeInsets.all(16),
            child: MaterialButton(
              onPressed: viewModel.loadCourses,
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
