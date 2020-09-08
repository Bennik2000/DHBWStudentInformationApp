import 'dart:async';
import 'dart:isolate';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

///
/// ScheduleSource decorator which executes the [querySchedule] in a separated isolate
///
class IsolateScheduleSourceDecorator extends ScheduleSource {
  final ScheduleSource _scheduleSource;

  Stream _isolateToMain;
  Isolate _isolate;
  SendPort _sendPort;

  IsolateScheduleSourceDecorator(this._scheduleSource);

  @override
  Future<Schedule> querySchedule(DateTime from, DateTime to,
      [CancellationToken cancellationToken]) async {
    await _initializeIsolate();

    // Use the cancellation token to send a cancel message.
    // The isolate then uses a new instance to cancel the request
    cancellationToken.setCancellationCallback(() {
      _sendPort.send({"type": "cancel"});
    });

    _sendPort.send({
      "type": "execute",
      "source": _scheduleSource,
      "from": from,
      "to": to,
    });

    final completer = Completer<Schedule>();
    final subscription = _isolateToMain.listen((result) {
      cancellationToken.setCancellationCallback(null);
      completer.complete(result);
    });

    final result = await completer.future;
    subscription.cancel();

    return result;
  }

  Future<void> _initializeIsolate() async {
    if (_isolate != null && _isolateToMain != null && _sendPort != null) return;

    var isolateToMain = ReceivePort();

    // Use a broadcast stream. The normal ReceivePort closes after one subscription
    _isolateToMain = isolateToMain.asBroadcastStream();
    _isolate = await Isolate.spawn(
        scheduleSourceIsolateEntryPoint, isolateToMain.sendPort);
    _sendPort = await _isolateToMain.first;
  }

  @override
  void setEndpointUrl(String url) {
    _scheduleSource.setEndpointUrl(url);
  }

  @override
  void validateEndpointUrl(String url) {
    _scheduleSource.validateEndpointUrl(url);
  }
}

void scheduleSourceIsolateEntryPoint(SendPort sendPort) async {
  // Using the given send port, send back a send port for two way communication
  var port = ReceivePort();
  sendPort.send(port.sendPort);

  CancellationToken token;

  await for (var message in port) {
    if (message["type"] == "execute") {
      token = CancellationToken();
      executeQueryScheduleMessage(message, sendPort, token);
    } else if (message["type"] == "cancel") {
      token?.cancel();
    }
  }
}

Future<void> executeQueryScheduleMessage(
  Map<String, dynamic> map,
  SendPort sendPort,
  CancellationToken token,
) async {
  try {
    ScheduleSource source = map["source"];
    DateTime from = map["from"];
    DateTime to = map["to"];

    var result = await source.querySchedule(from, to, token);

    sendPort.send(result);
  } on OperationCancelledException catch (_) {
    sendPort.send(null);
  }
}
