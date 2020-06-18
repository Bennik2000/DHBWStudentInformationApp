///
/// Override this class in order to receive a background callback
///
abstract class TaskCallback {
  Future<void> run();
}
