import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'overlay_widget.dart';
import 'dart:developer' as dev;

class LoggerView {
  var isVisible = false;
  static LoggerView? _instance;

  LoggerView._();

  ButtonOverlayWidget? _buttonOverlay;

  final LoggerOverlayWidget _loggerWidget = LoggerOverlayWidget();

  void showOverlay(OverlayState? overlayState) {
    _buttonOverlay ??= ButtonOverlayWidget(
      onPressed: () {
        isVisible = !isVisible;
        if (isVisible) {
          _loggerWidget.showOverlay(
              overlayState, below: _buttonOverlay?.getEntry());
        } else {
          _loggerWidget.hideOverlay();
        }
      },
      onLongPressed: () {
        _loggerWidget.changeMode();
      },);
    _buttonOverlay?.showOverlay(overlayState);
  }

  void hideOverlay() {}

  void log(String tag, String msg) {
    var message = "${DateTime.now()} : $tag : $msg";
    dev.log(message);
    _loggerWidget.putMsg(message);
  }

  static LoggerView getLoggerView() {
    _instance ??= LoggerView._();
    return _instance!;
  }
}