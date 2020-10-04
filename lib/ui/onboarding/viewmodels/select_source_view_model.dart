import 'package:dhbwstudentapp/common/data/preferences/preferences_provider.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_source_type.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';

class SelectSourceViewModel extends OnboardingStepViewModel {
  final PreferencesProvider preferencesProvider;

  ScheduleSourceType _scheduleSourceType = ScheduleSourceType.Rapla;
  ScheduleSourceType get scheduleSourceType => _scheduleSourceType;

  SelectSourceViewModel(this.preferencesProvider) {
    setIsValid(true);
  }

  void setScheduleSourceType(ScheduleSourceType type) {
    _scheduleSourceType = type;
    setIsValid(_scheduleSourceType != null);

    notifyListeners("scheduleSourceType");
  }

  @override
  Future<void> save() async {
    await preferencesProvider.setScheduleSourceType(_scheduleSourceType.index);
  }

  String nextStep() {
    switch (_scheduleSourceType) {
      case ScheduleSourceType.Rapla:
        return "rapla";
      case ScheduleSourceType.Dualis:
        return "dualis";
      case ScheduleSourceType.None:
        return "dualis";
    }

    return null;
  }
}
