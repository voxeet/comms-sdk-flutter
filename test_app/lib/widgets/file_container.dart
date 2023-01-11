import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management/models/conference_model.dart';

class FileContainer extends StatefulWidget {
  const FileContainer({Key? key}) : super(key: key);

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  @override
  Widget build(BuildContext context) {
    String imageSource = Provider.of<ConferenceModel>(context).imageSource;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Image.network(imageSource),
    );
  }
}
