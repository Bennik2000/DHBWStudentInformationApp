import 'package:dhbwstudentapp/schedule/business/schedule_source_provider.dart';
import 'package:dhbwstudentapp/schedule/service/mannheim/mannheim_course_scraper.dart';
import 'package:dhbwstudentapp/ui/onboarding/viewmodels/onboarding_view_model_base.dart';

enum LoadCoursesState {
  Loading,
  Loaded,
  Failed,
}

class MannheimViewModel extends OnboardingStepViewModel {
  final ScheduleSourceProvider _scheduleSourceProvider;

  LoadCoursesState _loadingState = LoadCoursesState.Loading;
  LoadCoursesState get loadingState => _loadingState;

  Course? _selectedCourse;
  Course? get selectedCourse => _selectedCourse;

  List<Course>? _courses;
  List<Course>? get courses => _courses;

  MannheimViewModel(this._scheduleSourceProvider) {
    setIsValid(false);
    loadCourses();
  }

  Future<void> loadCourses() async {
    _loadingState = LoadCoursesState.Loading;
    notifyListeners("loadingState");

    try {
      await Future.delayed(Duration(seconds: 1));
      _courses = await MannheimCourseScraper().loadCourses();
      _loadingState = LoadCoursesState.Loaded;
    } catch (ex) {
      _courses = null;
      _loadingState = LoadCoursesState.Failed;
    }

    notifyListeners("loadingState");
    notifyListeners("courses");
  }

  void setSelectedCourse(Course course) {
    if (_selectedCourse == course) {
      _selectedCourse = null;
    } else {
      _selectedCourse = course;
    }

    setIsValid(_selectedCourse != null);
  }

  @override
  Future<void> save() async {
    await _scheduleSourceProvider.setupForMannheim(selectedCourse);
  }
}
