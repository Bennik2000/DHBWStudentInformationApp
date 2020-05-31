typedef CancellationCallback = void Function();

class CancellationToken {
  bool _isCancelled = false;
  CancellationCallback _callback;

  bool isCancelled() {
    return _isCancelled;
  }

  void throwIfCancelled() {
    if (_isCancelled) {
      throw TokenCancelledException;
    }
  }

  void cancel() {
    _isCancelled = true;

    if (_callback != null) _callback();
  }

  void setCancellationCallback(CancellationCallback callback) {
    _callback = callback;
  }
}

mixin TokenCancelledException implements Exception {}
