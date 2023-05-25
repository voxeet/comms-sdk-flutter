import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableWidgt extends StatelessWidget {
  final Function(DragUpdateDetails)? onTap;
  final Widget child;

  DraggableWidgt({
    Key? key,
    this.onTap,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onPanUpdate: onTap,
      child: Card(
        color: Color.fromRGBO(0, 0, 0, 0),
        shadowColor: Color.fromRGBO(0, 0, 0, 0),
        borderOnForeground: false,
        child: child,
      ),
    );
  }

}