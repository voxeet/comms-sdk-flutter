import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import "dart:developer" as dev;

class VoiceFontDialogContent extends StatefulWidget {
  const VoiceFontDialogContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return VoiceFontDialogContentState();
  }
}

class VoiceFontDialogContentState extends State<VoiceFontDialogContent> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  var _selectedFont = VoiceFont.none;

  List<VoiceFont> fonts = VoiceFont.values;

  @override
  void initState() {
    super.initState();
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .getCaptureMode()
        .then((value) => setState(() {
      _selectedFont = value.voiceFont;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton(
          items: VoiceFont.values
              .map<DropdownMenuItem<VoiceFont>>((VoiceFont item) {
            return DropdownMenuItem<VoiceFont>(
              value: item,
              child: Text(item.name),
            );
          }).toList(),
          value: _selectedFont,
          onChanged: _onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('OK',
                  style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
                    .getCaptureMode()
                    .then((value) {
                  var newFont = value;
                  newFont.voiceFont = _selectedFont;
                  _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
                      .setCaptureMode(newFont)
                      .then((value) => dev.log("voice font updated"))
                      .onError((error, stackTrace) => dev.log("error appear during updating voice font: $error"));
                  Navigator.of(context).pop();
                }).onError((error, stackTrace) {
                  dev.log("Cannot get capture mode");
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: const Text('CANCEL',
                  style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
      ],
    );
  }

  void _onChanged(VoiceFont? value) {
    if (value != null) {
      setState(() {
        _selectedFont = value;
      });
    }
  }
}
