import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPresentationContainer extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final Widget videoPlayerWidget;

  const VideoPresentationContainer(
      {Key? key,
      required this.videoPlayerController,
      required this.videoPlayerWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
      child: videoPlayerWidget,
    );
  }
}
