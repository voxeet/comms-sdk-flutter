import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class NativeView extends StatefulWidget {

  final String viewType = 'view1';
  final Map<String, String> creationParams;

  const NativeView({super.key, required this.creationParams});

  @override
  _NativeViewState createState() => _NativeViewState();
}

class _NativeViewState extends State<NativeView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
          viewType: widget.viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: widget.creationParams,
          creationParamsCodec: const StandardMessageCodec()
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // IOS Native View
    }
    throw UnimplementedError();
  }
}
