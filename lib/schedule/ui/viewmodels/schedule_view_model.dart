import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';
import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

class ScheduleViewModel extends BaseViewModel {
  final ScheduleSourceProvider _scheduleSourceProvider;

  bool _didSetupProperly = false;

  bool get didSetupProperly => _didSetupProperly;

  ScheduleViewModel(this._scheduleSourceProvider) {
    _scheduleSourceProvider.onDidChangeScheduleSource =
        onDidChangeScheduleSource;
    _didSetupProperly = _scheduleSourceProvider.didSetupCorrectly();

    _scheduleSourceProvider.setupScheduleSource();
  }

  void onDidChangeScheduleSource(ScheduleSource scheduleSource, bool valid) {
    _didSetupProperly = valid;
    print("onDidChangeScheduleSource called");
    notifyListeners("didSetupProperly");
  }
}
