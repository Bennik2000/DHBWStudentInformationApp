import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class ScheduleViewModel extends BaseViewModel {
  final ScheduleSourceProvider _scheduleSourceSetup;

  bool _didSetupProperly = false;

  bool get didSetupProperly => _didSetupProperly;

  ScheduleViewModel(this._scheduleSourceSetup) {
    _scheduleSourceSetup.onDidChangeScheduleSource = onDidChangeScheduleSource;
    _didSetupProperly = _scheduleSourceSetup.didSetupCorrectly();
  }

  void onDidChangeScheduleSource(ScheduleSource scheduleSource, bool valid) {
    _didSetupProperly = valid;
    print("notifyListeners");
    notifyListeners("didSetupProperly");
  }
}
