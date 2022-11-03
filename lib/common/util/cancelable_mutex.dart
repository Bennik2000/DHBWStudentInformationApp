import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:mutex/mutex.dart';

class CancelableMutex {
  final Mutex _mutex = Mutex();
  CancellationToken? _token;
  CancellationToken? get token => _token;

  CancelableMutex();

  void cancel() {
    _token?.cancel();
  }

  Future acquireAndCancelOther() async {
    if (!(token?.isCancelled ?? false)) {
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
