import 'package:flutter/material.dart';
import 'draggable_widget.dart';

class ButtonOverlayWidget extends OverlayBaseWidget {
  void Function() onPressed;
  void Function()? onLongPressed;
  OverlayEntry? _overlayEntry;
  final FloatingButtonUpdateController _widgetUpdateController = FloatingButtonUpdateController();

  ButtonOverlayWidget({
    required this.onPressed,
    this.onLongPressed,
  });

  @override
  void showOverlay(OverlayState? overlayState, { OverlayEntry? above, OverlayEntry? below}) {
    _showOverlay(overlayState, null);
  }

  @override
  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(OverlayState? overlayState, DragUpdateDetails? d) async {
    if (_overlayEntry == null) {
      var overlayEntry = _createOverlay((context) =>
          FloatingButtonOverlay(
            onTap: (d) {
              _widgetUpdateController.updatePosition(
                  Offset(d.delta.dx, d.delta.dy));
            },
            onPressed: onPressed,
            onLongPressed: onLongPressed,
            controller: _widgetUpdateController,
          ));
      _overlayEntry = overlayEntry;
      overlayState?.insert(overlayEntry);
    }
  }

  OverlayEntry? getEntry() {
    return _overlayEntry;
  }
}

class LoggerOverlayWidget extends OverlayBaseWidget {
  OverlayEntry? _logsOverlayEntry;
  OverlayEntry? _dragButtonOverlayEntry;
  final FloatingButtonUpdateController _dragController = FloatingButtonUpdateController();
  final LogsListController _logsListController = LogsListController();
  bool isVisible = false;
  List<String> logs = [];
  final double dragButtonOffset = 25;
  double height = 240;
  bool _isScrollMode = true;

  @override
  void showOverlay(OverlayState? overlayState, { OverlayEntry? above, OverlayEntry? below}) {
    _showLogsOverlay(overlayState, null, above, below);
    _showDragButtonOverlay(overlayState, above, below);
    isVisible = true;
  }

  @override
  void hideOverlay() {
    _removeOverlay();
    isVisible = false;
  }

  void _showLogsOverlay(OverlayState? overlayState, DragUpdateDetails? d, OverlayEntry? above, OverlayEntry? below) {
    if (_logsOverlayEntry == null) {
      var overlayEntry = _createOverlay((context) =>
          LogsListWidget(
              controller: _logsListController,
              logs: logs,
              height: height
          )
      );

      overlayState?.insert(overlayEntry, above: above, below: below);
      _logsOverlayEntry = overlayEntry;
    }
  }

  void _showDragButtonOverlay(OverlayState? overlayState, OverlayEntry? above, OverlayEntry? below) {
    if (_dragButtonOverlayEntry == null) {
      var overlayEntry = _createOverlay((context) =>
          FloatingButtonOverlay(
            buttonSize: FloatingButtonSize.small,
            onTap: (d) {
              _dragController.updatePosition(Offset(0, d.delta.dy));
              height = _dragController.getPosition() + dragButtonOffset;
              _logsListController.changeHeight(height);
            },
            startPosition: FloatingPosition(left: 0, right: 0, bottom: height - dragButtonOffset),
            buttonIcon: Icons.drag_handle,
            backgroundColor: const Color.fromRGBO(180, 180, 180, 1),
            onPressed: () {},
            controller: _dragController,
          )
      );

      overlayState?.insert(overlayEntry, above: above, below: below);
      _dragButtonOverlayEntry = overlayEntry;
    }
  }

  void _removeOverlay() {
    if (_logsOverlayEntry != null) {
      _logsOverlayEntry?.remove();
      _logsOverlayEntry = null;
    }
    if (_dragButtonOverlayEntry != null) {
      _dragButtonOverlayEntry?.remove();
      _dragButtonOverlayEntry = null;
    }
  }

  void putMsg(String msg) {
    logs.insert(0, msg);
    _logsListController.updateLogs(logs);
  }

  void changeMode() {
    _isScrollMode = !_isScrollMode;
    if (_isScrollMode) {
      _logsListController.changeToScrollingMode();
    } else {
      _logsListController.changeToTransparentMode();
    }
  }
}

abstract class OverlayBaseWidget {

  void showOverlay(OverlayState overlayState, { OverlayEntry? above, OverlayEntry? below});

  void hideOverlay();

  @protected
  OverlayEntry _createOverlay(WidgetBuilder builder) {
    return OverlayEntry(builder: builder);
  }
}

class FloatingButtonOverlay extends StatefulWidget {
  final Function(DragUpdateDetails)? onTap;
  final VoidCallback? onPressed;
  final Function()? onLongPressed;
  final FloatingButtonUpdateController controller;
  final FloatingPosition startPosition;
  final IconData buttonIcon;
  final Color backgroundColor;
  final FloatingButtonSize buttonSize;

  const FloatingButtonOverlay({
    Key? key,
    this.onTap,
    this.onPressed,
    this.onLongPressed,
    required this.controller,
    this.startPosition = const FloatingPosition(left: 0, top: 20),
    this.buttonIcon = Icons.logo_dev,
    this.backgroundColor = Colors.black,
    this.buttonSize = FloatingButtonSize.regular
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => FloatingButtonOverlayState();
}

enum FloatingButtonSize {
  small,
  regular,
  large
}

class FloatingButtonOverlayState extends State<FloatingButtonOverlay> {
  late FloatingPosition _position;

  FloatingButtonOverlayState();

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _position = widget.startPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _position.left,
        top: _position.top,
        right: _position.right,
        bottom: _position.bottom,
        child:
        DraggableWidget(
          onTap: widget.onTap,
          child: _createButton(context),
        )
    );
  }

  Widget _createButton(BuildContext context) {
    FloatingActionButton floatingActionButton;
    switch(widget.buttonSize) {
      case FloatingButtonSize.small:
        floatingActionButton = FloatingActionButton.small(
          onPressed: widget.onPressed,
          backgroundColor: widget.backgroundColor,
          child: Icon(widget.buttonIcon),
        );
        break;
      case FloatingButtonSize.large:
        floatingActionButton = FloatingActionButton.large(
          onPressed: widget.onPressed,
          backgroundColor: widget.backgroundColor,
          child: Icon(widget.buttonIcon),
        );
        break;
      default:
        floatingActionButton = FloatingActionButton(
          onPressed: widget.onPressed,
          backgroundColor: widget.backgroundColor,
          child: Icon(widget.buttonIcon),

        );
    }
    return InkWell(
      onLongPress: widget.onLongPressed,
      child: floatingActionButton,
    );
  }

  void _updatePosition(Offset offset) {
    var left = _position.left;
    var right = _position.right;
    var top = _position.top;
    var bottom = _position.bottom;
    if (left != null) {
      left += offset.dx;
    } else if (right != null) {
      right -= offset.dx;
    }
    if (top != null) {
      top += offset.dy;
    } else if (bottom != null) {
      bottom -= offset.dy;
    }
    setState(() {
      _position = FloatingPosition(left: left, right: right, top: top, bottom: bottom);
    });
  }

  void update(Function() action) {
    setState(() {
      action.call();
    });
  }
}

class FloatingButtonUpdateController {
  FloatingButtonOverlayState? _state;
  void updatePosition(Offset offset) {
    _state?._updatePosition(offset);
  }

  double getPosition() {
    return _state?._position.bottom ?? 0;
  }

  void dispose() {
    _state = null;
  }
}

class FloatingPosition {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  const FloatingPosition({
    this.left,
    this.right,
    this.top,
    this.bottom
  });
}

class LogsListWidget extends StatefulWidget {
  final LogsListController controller;
  final List<String> logs;
  final double height;
  const LogsListWidget({
    super.key,
    required this.controller,
    required this.logs,
    this.height = 0
  });

  @override
  State<StatefulWidget> createState() {
    return _LogsListWidgetState();
  }
}

class _LogsListWidgetState extends State<LogsListWidget> {
  late List<String> _logs;
  bool _ignorePointers = false;
  double _height = 0;
  Color _backgroundColor = const Color(0x992979FF);

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _logs = widget.logs;
    _height = widget.height >= 0 ? widget.height : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: IgnorePointer(
            ignoring: _ignorePointers,
            child: Container(
                height: _height,
                color: _backgroundColor,
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Text(
                        _logs[index], style: _getLogTextStyle(context));
                  },
                )
            )
        )
    );
  }

  TextStyle _getLogTextStyle(BuildContext context) {
    return DefaultTextStyle
        .of(context)
        .style
        .apply(fontSizeFactor: 0.25, color: Colors.black, decorationColor: null);
  }

  void _updateLogs(List<String> logs) {
    setState(() {
      _logs = logs;
    });
  }

  void _changeHeight(double newHeight) {
    setState(() {
      _height = newHeight >= 0 ? newHeight : 0;
    });
  }

  void changeToScrollingMode() {
    setState(() {
      _backgroundColor = const Color(0x992979FF);
      _ignorePointers = false;
    });
  }

  void changeToTransparentMode() {
    setState(() {
      _backgroundColor = const Color(0x222979FF);
      _ignorePointers = true;
    });
  }
}

class LogsListController {
  _LogsListWidgetState? _state;

  void dispose() {
    _state = null;
  }

  void updateLogs(List<String> logs) {
    _state?._updateLogs(logs);
  }

  void changeHeight(double newHeight) {
    _state?._changeHeight(newHeight);
  }

  void changeToScrollingMode() {
    _state?.changeToScrollingMode();
  }

  void changeToTransparentMode() {
    _state?.changeToTransparentMode();
  }
}