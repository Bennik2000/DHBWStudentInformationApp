import 'dart:async';
import 'dart:isolate';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule_query_result.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

///
/// ScheduleSource decorator which executes the [querySchedule] in a separated isolate
///
class IsolateScheduleSourceDecorator extends ScheduleSource {
  final ScheduleSource _scheduleSource;

  Stream? _isolateToMain;
  Isolate? _isolate;
  SendPort? _sendPort;

  IsolateScheduleSourceDecorator(this._scheduleSource);

  @override
  Future<ScheduleQueryResult?> querySchedule(
    DateTime? from,
    DateTime? to, [
    CancellationToken? cancellationToken,
  ]) async {
    await _initializeIsolate();

    // Use the cancellation token to send a cancel message.
    // The isolate then uses a new instance to cancel the request
    cancellationToken!.cancellationCallback =
        () => _sendPort!.send({"type": "cancel"});

    _sendPort!.send({
      "type": "execute",
      "source": _scheduleSource,
      "from": from,
      "to": to,
    });

    final completer = Completer<ScheduleQueryResult?>();

    ScheduleQueryFailedException? potentialException;

    final subscription = _isolateToMain!.listen((result) {
      cancellationToken.cancellationCallback = null;

      // TODO: [Leptopoda] validate changes
      if (result == null || result is! ScheduleQueryResult) {
        potentialException = ScheduleQueryFailedException(result);
        completer.complete();
      } else {
        completer.complete(result);
      }
    });

    final result = await completer.future;

    subscription.cancel();

    if (potentialException != null) {
      throw potentialException!;
    }

    return result;
  }

  Future<void> _initializeIsolate() async {
    if (_isolate != null && _isolateToMain != null && _sendPort != null) return;

    final isolateToMain = ReceivePort();

    // Use a broadcast stream. The normal ReceivePort closes after one subscription
    _isolateToMain = isolateToMain.asBroadcastStream();
    _isolate = await Isolate.spawn(
      _scheduleSourceIsolateEntryPoint,
      isolateToMain.sendPort,
    );
    _sendPort = await _isolateToMain!.first as SendPort?;
  }

  @override
  bool canQuery() {
    return _scheduleSource.canQuery();
  }
}

Future<void> _scheduleSourceIsolateEntryPoint(SendPort sendPort) async {
  // Using the given send port, send back a send port for two way communication
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  CancellationToken? token;

  await for (final message in port) {
    message as Map<String, dynamic>;
    if (message["type"] == "execute") {
      token = CancellationToken();
      _executeQueryScheduleMessage(message, sendPort, token);
    } else if (message["type"] == "cancel") {
      token?.cancel();
    }
  }
}

Future<void> _executeQueryScheduleMessage(
  Map<String, dynamic> map,
  SendPort sendPort,
  CancellationToken? token,
) async {
  try {
    final ScheduleSource source = map["source"] as ScheduleSource;
    final DateTime? from = map["from"] as DateTime?;
    final DateTime? to = map["to"] as DateTime?;

    final result = await source.querySchedule(from, to, token);

    sendPort.send(result);
  } on OperationCancelledException catch (_) {
    sendPort.send(null);
  } catch (ex, trace) {
    sendPort.send("$ex \n$trace");
  }
}
