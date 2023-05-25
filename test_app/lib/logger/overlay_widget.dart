import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'draggable_widget.dart';


class ButtonOverlayWidget extends OverlayBaseWidget {
  void Function() onPressed;
  Offset _offset = Offset.zero + const Offset(0, 20);
  OverlayEntry? _overlayEntry;
  late final WidgetBuilder _builder = (context) {
    return Positioned(
        left: _offset.dx,
        top: _offset.dy,
        child:
        DraggableWidgt(
          onTap: (d) => _showOverlay(context.findRootAncestorStateOfType<OverlayState>(), d),
          child: FloatingActionButton(
            onPressed: this.onPressed,
            backgroundColor: Colors.black,
            child: Icon(Icons.logo_dev),
          ),
        )
    );
  };

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
      var overlayEntry = _createOverlay(_builder);
      // overlayEntry.markNeedsBuild();

      overlayState?.insert(overlayEntry);
      _overlayEntry = overlayEntry;
    }

    overlayState?.setState(() {
      if (d != null) {
        _offset += Offset(d.delta.dx, d.delta.dy);
      }
    });
  }

  OverlayEntry? getEntry() {
    return _overlayEntry;
  }
}

class LoggerOverlayWidget extends OverlayBaseWidget {
  OverlayEntry? _overlayEntry;
  bool isVisible = false;
  List<String> loggs = [];

  late final WidgetBuilder _builder = (context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
            height: 240.0,
            color: Colors.yellow,
            child: ListView.builder(
              itemCount: loggs.length,
              itemBuilder: (context, index) {
                return Text(loggs[index], style: _getLogTextStyle(context));
              },
            )
        )
    );
  };

  void showOverlay(OverlayState? context, { OverlayEntry? above, OverlayEntry? below}) {
    _showOverlay(context, null, above, below);
    isVisible = true;
  }

  void hideOverlay() {
    _removeOverlay();
    isVisible = false;
  }

  TextStyle _getLogTextStyle(BuildContext context) {
    return DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.3);
  }

  void _showOverlay(OverlayState? overlayState, DragUpdateDetails? d, OverlayEntry? above, OverlayEntry? below) {
    if (_overlayEntry == null) {
      var overlayEntry = _createOverlay(_builder);
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