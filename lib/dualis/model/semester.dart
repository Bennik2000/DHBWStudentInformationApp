import 'package:dhbwstudentapp/dualis/model/module.dart';

class Semester {
  final String? name;
  final List<Module> modules;

  const Semester(
    this.name,
    this.modules,
  );
}
