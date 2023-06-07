import 'package:flutter/material.dart';
import 'draggable_widget.dart';

class ButtonOverlayWidget extends OverlayBaseWidget {
  void Function() onPressed;
  OverlayEntry? _overlayEntry;
  final FloatingButtonUpdateController _widgetUpdateController = FloatingButtonUpdateController();

  ButtonOverlayWidget({
    required this.onPressed
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
      var overlayEntry = _createOverlay((context) => FloatingButtonOverlay(
          onTap: (d) {
            _widgetUpdateController.updatePosition(Offset(d.delta.dx, d.delta.dy));
          },
         onPressed: onPressed,
        controller: _widgetUpdateController,
      ));
      _overlayEntry = overlayEntry;
      _overlayEntry.markNeedsBuild()
      // overlayEntry.markNeedsBuild();

      overlayState?.insert(overlayEntry);

    }
  }

  OverlayEntry? getEntry() {
    return _overlayEntry;
  }
}

class LoggerOverlayWidget extends OverlayBaseWidget {
  OverlayEntry? _overlayEntry;
  bool isVisible = false;
  List<String> loggs = [];

  @override
  void showOverlay(OverlayState? overlayState, { OverlayEntry? above, OverlayEntry? below}) {
    _showOverlay(overlayState, null, above, below);
    isVisible = true;
  }

  @override
  void hideOverlay() {
    _removeOverlay();
    isVisible = false;
  }

  TextStyle _getLogTextStyle(BuildContext context) {
    return DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.3);
  }

  void _showOverlay(OverlayState? overlayState, DragUpdateDetails? d, OverlayEntry? above, OverlayEntry? below) {
    if (_overlayEntry == null) {
      var overlayEntry = _createOverlay((context) =>
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  height: 240.0,
                  color: Colors.yellow,
                  child: ListView.builder(
                    itemCount: loggs.length,
                    itemBuilder: (context, index) {
                      return Text(
                          loggs[index], style: _getLogTextStyle(context));
                    },
                  )
              )
          )
      );
      overlayEntry.markNeedsBuild();

      overlayState?.insert(overlayEntry, above: above, below: below);
      _overlayEntry = overlayEntry;
    }
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void putMsg(String msg) {
    loggs.add(msg);
    _refreshWidget();
  }

  void _refreshWidget() {}
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
  final FloatingButtonUpdateController controller;

  const FloatingButtonOverlay({Key? key, this.onTap, this.onPressed, required this.controller}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FloatingButtonOverlayState(onTap, onPressed, controller);
  }
}

class FloatingButtonOverlayState extends State<FloatingButtonOverlay> {
  Offset _offset = Offset.zero + const Offset(0, 20);
  final Function(DragUpdateDetails)? _onTap;
  final VoidCallback? _onPressed;
  final FloatingButtonUpdateController _controller;

  FloatingButtonOverlayState(this._onTap, this._onPressed, this._controller) {
    _controller.state = this;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _offset.dx,
        top: _offset.dy,
        child:
        DraggableWidget(
          onTap: _onTap,
          child: FloatingActionButton(
            onPressed: _onPressed,
            backgroundColor: Colors.black,
            child: const Icon(Icons.logo_dev),
          ),
        )
    );
  }

  void _updatePosition(Offset offset) {
    setState(() {
      _offset += offset;
    });
  }
}

class FloatingButtonUpdateController {
  FloatingButtonOverlayState? state;
  void updatePosition(Offset offset) {
    state?._updatePosition(offset);
  }

  void setState(FloatingButtonOverlayState state) {
    this.state = state;
  }

  void dispose() {
    state = null;
  }
}