import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_management/models/conference_model.dart';

class ConferenceTitle extends StatefulWidget {
  const ConferenceTitle({Key? key}) : super(key: key);

  @override
  State<ConferenceTitle> createState() => _ConferenceTitleState();
}

class _ConferenceTitleState extends State<ConferenceTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          getConferenceName(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  String getConferenceName() {
    var conferenceName =
        Provider.of<ConferenceModel>(context).conference.alias ??
            "Invalid alias";
    return conferenceName;
  }
}
