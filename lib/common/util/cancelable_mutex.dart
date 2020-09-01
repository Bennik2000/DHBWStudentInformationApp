import 'package:mutex/mutex.dart';
import 'cancellation_token.dart';

class CancelableMutex {
  Mutex _mutex = Mutex();
  CancellationToken _token;
  CancellationToken get token => _token;

  void cancel() {
    _token?.cancel();
  }

  Future acquireAndCancelOther() async {
    if (!(token?.isCancelled() ?? false)) {
      token?.cancel();
    }

    await _mutex.acquire();

    _token = CancellationToken();
  }

  void release() {
    _mutex.release();
    _token = null;
  }
}
