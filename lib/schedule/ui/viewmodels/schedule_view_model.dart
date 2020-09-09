import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_setup.dart';

class ScheduleViewModel extends BaseViewModel {
  final ScheduleSourceSetup _scheduleSourceSetup;

  bool _didSetupProperly = false;

  bool get didSetupProperly => _didSetupProperly;

  ScheduleViewModel(this._scheduleSourceSetup) {
    _scheduleSourceSetup.onDidApplyNewUrl = onDidApplyNewUrl;

    initScheduleSource();
  }

  void initScheduleSource() async {
    _didSetupProperly = await _scheduleSourceSetup.setupScheduleSource();

    notifyListeners("didSetupProperly");
  }

  void onDidApplyNewUrl(bool valid) {
    _didSetupProperly = valid;
    print("notifyListeners");
    notifyListeners("didSetupProperly");
  }
}
