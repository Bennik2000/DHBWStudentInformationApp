///
/// Override this class in order to receive a background callback
///
abstract class TaskCallback {
  Future<void> run();

  Future<void> schedule();

  Future<void> cancel();

  String getName();
}
