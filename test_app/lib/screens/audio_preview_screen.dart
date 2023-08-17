import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import '/widgets/dolby_title.dart';
import '/widgets/primary_button.dart';
import 'dart:developer' as developer;

class AudioPreviewScreen extends StatefulWidget {
  const AudioPreviewScreen({Key? key}) : super(key: key);

  @override
  State<AudioPreviewScreen> createState() => _AudioPreviewScreenState();
}

class _AudioPreviewScreenState extends State<AudioPreviewScreen> {
  VoiceFont selectedVoiceFont = VoiceFont.none;
  AudioCaptureMode selectedAudioCaptureMode = AudioCaptureMode.standard;
  NoiseReduction selectedNoiseReduction = NoiseReduction.low;
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(color: Colors.deepPurple),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<AudioCaptureMode>(
                              focusColor: Colors.white,
                              value: selectedAudioCaptureMode,
                              style: const TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: AudioCaptureMode.values
                                  .map<DropdownMenuItem<AudioCaptureMode>>(
                                      (AudioCaptureMode value) {
                                return DropdownMenuItem<AudioCaptureMode>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (AudioCaptureMode? audioCaptureMode) {
                                setState(() {
                                  selectedAudioCaptureMode = audioCaptureMode!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButton<NoiseReduction>(
                              focusColor: Colors.white,
                              value: selectedNoiseReduction,
                              style: const TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: NoiseReduction.values
                                  .map<DropdownMenuItem<NoiseReduction>>(
                                      (NoiseReduction value) {
                                return DropdownMenuItem<NoiseReduction>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (NoiseReduction? noiseReduction) {
                                setState(() {
                                  selectedNoiseReduction = noiseReduction!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButton<VoiceFont>(
                              focusColor: Colors.white,
                              value: selectedVoiceFont,
                              style: const TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: VoiceFont.values
                                  .map<DropdownMenuItem<VoiceFont>>(
                                      (VoiceFont value) {
                                return DropdownMenuItem<VoiceFont>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (VoiceFont? voiceFont) {
                                setState(() {
                                  selectedVoiceFont = voiceFont!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SecondaryButton(
                                  text: 'Record',
                                  onPressed: () {
                                    record();
                                  },
                                  color: Colors.deepPurple,
                                ),
                                SecondaryButton(
                                  text: 'Play',
                                  onPressed: () {
                                    play();
                                  },
                                  color: Colors.deepPurple,
                                ),
                                SecondaryButton(
                                  text: 'Stop',
                                  onPressed: () {
                                    stop();
                                  },
                                  color: Colors.deepPurple,
                                ),
                                SecondaryButton(
                                  text: 'Release',
                                  onPressed: () {
                                    release();
                                  },
                                  color: Colors.deepPurple,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              widgetText: const Text(
                                  'Set capture mode with chosen options'),
                              onPressed: () {
                                setCaptureMode();
                              },
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              widgetText: const Text('Back to join screen'),
                              onPressed: () {
                                navigateToJoinScreen(context);
                              },
                              color: Colors.deepPurple,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToJoinScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> setCaptureMode() async {
    try {
      var options = AudioCaptureOptions(
          selectedAudioCaptureMode, selectedNoiseReduction,
          voiceFont: selectedVoiceFont);
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
          .setCaptureMode(options);
      developer.log("setCaptureMode success");
    } catch (error) {
      developer.log("Error during setCaptureMode: $error");
    }
  }

  Future<void> play() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
          .play(false);
      developer.log("play success");
    } catch (error) {
      developer.log("Error during play: $error");
    }
  }

  Future<void> record() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
          .record(3);
      developer.log("record success");
    } catch (error) {
      developer.log("Error during record: $error");
    }
  }

  Future<void> stop() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
          .stop();
      developer.log("stop success");
    } catch (error) {
      developer.log("Error during stop $error");
    }
  }

  Future<void> release() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
          .release();
      developer.log("release success");
    } catch (error) {
      developer.log("Error during release: $error");
    }
  }
}
