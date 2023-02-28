import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/state_management/models/conference_model.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/file_container.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dialogs.dart';

class FilePresentationUI extends StatefulWidget {
  const FilePresentationUI({Key? key}) : super(key: key);

  @override
  State<FilePresentationUI> createState() => _FilePresentationUIState();
}

class _FilePresentationUIState extends State<FilePresentationUI> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    int amountOfPagesInDocument =
        Provider.of<ConferenceModel>(context, listen: false)
            .amountOfPagesInDocument;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Page: $pageNumber/$amountOfPagesInDocument"),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (pageNumber > 0) {
                          setState(() => pageNumber--);
                          await _dolbyioCommsSdkFlutterPlugin.filePresentation
                              .setPage(pageNumber);

                          String imageSource =
                              await _dolbyioCommsSdkFlutterPlugin
                                  .filePresentation
                                  .getImage(pageNumber);
                          setState(() {
                            Provider.of<ConferenceModel>(context, listen: false)
                                .imageSource = imageSource;
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_left_sharp),
                      color: pageNumber > 0 ? Colors.deepPurple : Colors.grey),
                  const FileContainer(),
                  IconButton(
                      onPressed: () async {
                        if (pageNumber < amountOfPagesInDocument) {
                          setState(() => pageNumber++);
                          await _dolbyioCommsSdkFlutterPlugin.filePresentation
                              .setPage(pageNumber);

                          String imageSource =
                              await _dolbyioCommsSdkFlutterPlugin
                                  .filePresentation
                                  .getImage(pageNumber);
                          setState(() {
                            Provider.of<ConferenceModel>(context, listen: false)
                                .imageSource = imageSource;
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_right_sharp),
                      color: pageNumber < amountOfPagesInDocument
                          ? Colors.deepPurple
                          : Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                runSpacing: 4,
                spacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  SecondaryButton(
                      text: 'getCurrent',
                      onPressed: () => getCurrent(),
                      fillWidth: false),
                  SecondaryButton(
                      text: 'getImage',
                      onPressed: () => getImage(),
                      fillWidth: false),
                  SecondaryButton(
                      text: 'getThumbnail',
                      onPressed: () => getThumbnail(),
                      fillWidth: false),
                  SecondaryButton(
                      text: 'stopFilePresentation',
                      onPressed: () => stopFilePresentation(),
                      color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  Future<void> getCurrent() async {
    try {
      var filePresentation =
          await _dolbyioCommsSdkFlutterPlugin.filePresentation.getCurrent();
      if (!mounted) return;
      showDialog(context, 'Success', filePresentation.toJson().toString());
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error: ', error.toString());
    }
  }

  Future<void> getImage() async {
    try {
      var value = await _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getImage(pageNumber);
      if (!mounted) return;
      showDialog(context, 'Success', value);
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error: ', error.toString());
    }
  }

  Future<void> getThumbnail() async {
    try {
      var value = await _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getThumbnail(pageNumber);
      if (!mounted) return;
      showDialog(context, 'Success', value);
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error: ', error.toString());
    }
  }

  Future<void> stopFilePresentation() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.filePresentation.stop();
      if (!mounted) return;
      showDialog(context, 'Success', 'ok');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error: ', error.toString());
    }
  }
}
