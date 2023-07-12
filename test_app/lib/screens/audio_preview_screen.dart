import 'package:flutter/material.dart';
import '/widgets/dolby_title.dart';
import '/widgets/primary_button.dart';

class AudioPreviewScreen extends StatelessWidget {
  const AudioPreviewScreen({Key? key}) : super(key: key);

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
}
