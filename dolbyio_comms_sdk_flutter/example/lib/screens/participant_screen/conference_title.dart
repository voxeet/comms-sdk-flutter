import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';

class ConferenceTitle extends StatefulWidget {
  final Future<Conference?> conference;
  const ConferenceTitle({Key? key, required this.conference}) : super(key: key);

  @override
  State<ConferenceTitle> createState() => _ConferenceTitleState();
}

class _ConferenceTitleState extends State<ConferenceTitle> {
  String conferenceName = '';

  @override
  void initState() {
    conferenceName = getConferenceName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
          child: Text(conferenceName, style: const TextStyle(fontSize: 16))
      ),
    );
  }

  String getConferenceName() {
    widget.conference.then((current) {
      setState(() => conferenceName = current!.alias.toString());
    });
    return conferenceName;
  }
}
