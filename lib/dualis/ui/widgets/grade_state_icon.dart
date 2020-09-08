import 'package:dhbwstudentapp/dualis/model/exam.dart';
import 'package:flutter/material.dart';

class GradeStateIcon extends StatelessWidget {
  final ExamState state;

  const GradeStateIcon({
    Key key,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ExamState.Passed:
        return const Icon(Icons.check, color: Colors.green);
      case ExamState.Failed:
        return const Icon(Icons.close, color: Colors.red);
      case ExamState.Pending:
        return Container();
    }

    return Container();
  }
}
