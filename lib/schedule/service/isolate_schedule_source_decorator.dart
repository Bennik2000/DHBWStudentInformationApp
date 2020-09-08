import 'dart:async';
import 'dart:isolate';

import 'package:dhbwstudentapp/common/util/cancellation_token.dart';
import 'package:dhbwstudentapp/schedule/model/schedule.dart';
import 'package:dhbwstudentapp/schedule/service/schedule_source.dart';

scheduleSourceIsolateEntryPoint(SendPort sendPort) async {
  var port = ReceivePort();
  sendPort.send(port.sendPort);

  CancellationToken token;

  await for (var message in port) {
    if (message["type"] == "execute") {
      token = CancellationToken();
      executeQuerySchedule(message, sendPort, token);
    } else if (message["type"] == "cancel") {
      token?.cancel();
    }
  }
}

Future<void> executeQuerySchedule(
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

    // Use a broadcast stream. The normal RecievePort closes after one subscription
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
