import 'package:dhbwstudentapp/dualis/model/module.dart';
import 'package:dhbwstudentapp/dualis/model/semester.dart';

class StudyGrades {
  final double gpaTotal;
  final double gpaMainModules;
  final double creditsTotal;
  final double creditsGained;

  StudyGrades(
    this.gpaTotal,
    this.gpaMainModules,
    this.creditsTotal,
    this.creditsGained,
  );
}
