typedef CancellationCallback = void Function();

class CancellationToken {
  bool _isCancelled = false;
  CancellationCallback? _callback;

  bool isCancelled() {
    return _isCancelled;
  }

  void throwIfCancelled() {
    if (_isCancelled) {
      throw OperationCancelledException();
    }
  }

  void cancel() {
    _isCancelled = true;

    _callback?.call();
  }

  void setCancellationCallback(CancellationCallback? callback) {
    _callback = callback;
  }
}

class OperationCancelledException implements Exception {}
