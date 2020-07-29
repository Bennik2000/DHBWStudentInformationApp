import 'package:dhbwstudentapp/common/ui/viewmodels/base_view_model.dart';

abstract class OnboardingViewModelBase extends BaseViewModel {
  bool _isValid = false;
  bool get isValid => _isValid;

  void setIsValid(bool isValid) {
    _isValid = isValid;
    notifyListeners("isValid");
  }

  void save();
}
