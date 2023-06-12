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
      var overlayEntry = _createOverlay((context) =>
          FloatingButtonOverlay(
            onTap: (d) {
              _widgetUpdateController.updatePosition(
                  Offset(d.delta.dx, d.delta.dy));
            },
            onPressed: onPressed,
            controller: _widgetUpdateController,
          ));
      _overlayEntry = overlayEntry;
      overlayState?.insert(overlayEntry);
    } else {
      _overlayEntry?.markNeedsBuild();
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
  double height = 240.0;

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
                      height: height,
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

      overlayState?.insert(overlayEntry, above: above, below: below);
      _overlayEntry = overlayEntry;
    } else {
      _overlayEntry?.markNeedsBuild();
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
  State<StatefulWidget> createState() => _FloatingButtonOverlayState();
}

class _FloatingButtonOverlayState extends State<FloatingButtonOverlay> {
  Offset _offset = Offset.zero + const Offset(0, 20);

  _FloatingButtonOverlayState();

  @override
  void initState() {
    super.initState();
    widget.controller.state = this;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _offset.dx,
        top: _offset.dy,
        child:
        DraggableWidget(
          onTap: widget.onTap,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
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
  _FloatingButtonOverlayState? state;
  void updatePosition(Offset offset) {
    state?._updatePosition(offset);
  }

  void dispose() {
    state = null;
  }
}