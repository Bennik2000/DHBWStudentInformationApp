typedef CancellationCallback = void Function();

class CancellationToken {
  bool _isCancelled = false;
  CancellationCallback? _callback;

  CancellationToken([this._callback]);

  bool get isCancelled => _isCancelled;

  void throwIfCancelled() {
    if (_isCancelled) {
      throw OperationCancelledException();
    }
  }

  void cancel() {
    _isCancelled = true;

    _callback?.call();
  }

  set cancellationCallback(CancellationCallback? callback) {
    _callback = callback;
  }
}

class OperationCancelledException implements Exception {}
