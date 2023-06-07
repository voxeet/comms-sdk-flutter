import 'package:flutter/material.dart';

class DraggableWidget extends StatelessWidget {
  final Function(DragUpdateDetails)? onTap;
  final Widget child;

  const DraggableWidget({
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
        color: const Color.fromRGBO(0, 0, 0, 0),
        shadowColor: const Color.fromRGBO(0, 0, 0, 0),
        borderOnForeground: false,
        child: child,
      ),
    );
  }

}