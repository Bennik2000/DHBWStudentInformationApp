import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';

enum ScheduleSourceType {
  Rapla,
  Dualis,
  None,
}

class SelectSourceOnboardingViewModel extends OnboardingStepViewModel {
  ScheduleSourceType _scheduleSourceType;
  ScheduleSourceType get scheduleSourceType => _scheduleSourceType;

  void setScheduleSourceType(ScheduleSourceType type) {
    _scheduleSourceType = type;
    notifyListeners("scheduleSourceType");
  }

  @override
  void save() {}

  List<String> nextStep() {
    switch (_scheduleSourceType) {
      case ScheduleSourceType.Rapla:
        return ["Rapla"];
      case ScheduleSourceType.Dualis:
        return ["Dualis"];
      case ScheduleSourceType.None:
        return [];
    }
  }
}
