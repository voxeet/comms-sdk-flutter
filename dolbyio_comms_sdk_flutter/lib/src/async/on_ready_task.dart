import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';

typedef Condition = bool Function();
typedef OnFinishAction = Future<void> Function();

class OnReadyTask {

  Duration? _timeout;
  final Condition _condition;
  final OnFinishAction _action;
  int startTime = -1;
  Future<void>? _actualTask;
  void Function()? _onTimeout;
  StreamSubscription<void>? _streamSubscription;

  // @internal
  OnReadyTask._construct(this._condition, this._action);

  void setTimeout(Duration timeout, void Function() onTimeout) {
    _timeout = timeout;
    _onTimeout = onTimeout;
  }

  void start() {
    _actualTask = _onReady();
    _streamSubscription = _actualTask?.asStream().listen((event) {developer.log("on event");});
  }

  void cancel() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _actualTask = null;
  }

  Future<void>? getTask() {
    return _actualTask;
  }

  bool isStarted() {
    return _actualTask != null && !_isTimeout();
  }

  Future<void> _onReady() async {
    return await Future.delayed(const Duration(seconds: 1), () async {
      developer.log("[KB] onReady: ${_condition()}");
      if (_condition()) {
        return _action();
      } else {
        if (_isTimeout()) {
          cancel();
          _onTimeout?.call();
          return Future.error("Timeout");
        }
        return _onReady();
      }
    });
  }

  bool _isTimeout() {
    var lTimeout = _timeout;
    if (lTimeout == null) {
      return false;
    }
    int actualTime = DateTime.now().millisecond;
    return lTimeout.inMilliseconds > (actualTime - startTime);
  }


  static OnReadyTask createOnReadyTask(Condition c, OnFinishAction action) {
    var result = OnReadyTask._construct(c, action);

    result.setTimeout(const Duration(seconds: 5), () {
      developer.log("[TIMEOUT] task reach time limit");
    });
    return result;
  }
}