import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'overlay_widget.dart';

class LoggerWidget {
  var isVisible = false;
  static LoggerWidget? _instance;

  LoggerWidget._();

  ButtonOverlayWidget? _buttonOverlay;

  final LoggerOverlayWidget _loggerWidget = LoggerOverlayWidget();

  void showOverlay(OverlayState? overlayState) {
    _buttonOverlay ??= ButtonOverlayWidget(
          onPressed: () {
            isVisible = !isVisible;
            if (isVisible) {
              _loggerWidget.showOverlay(overlayState, below: _buttonOverlay?.getEntry());
            } else {
              _loggerWidget.hideOverlay();
            }
          });
    _buttonOverlay?.showOverlay(overlayState);
  }

  void hideOverlay() {}

  void log(String tag, String msg) {
    var message = "${DateTime.now()} : $tag : $msg";
    _loggerWidget.putMsg(message);
  }

  static LoggerWidget getLoggerView() {
    _instance ??= LoggerWidget._();
    return _instance!;
  }
}