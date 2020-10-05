import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';

abstract class OnboardingStepViewModel extends BaseViewModel {
  bool _isValid = false;
  bool get isValid => _isValid;

  void setIsValid(bool isValid) {
    _isValid = isValid;
    notifyListeners("isValid");
  }

  Future<void> save();
}
