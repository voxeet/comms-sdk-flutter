import 'package:flutter/material.dart';

class DolbyTitle extends StatefulWidget {
  final String title;
  final String subtitle;

  const DolbyTitle({Key? key, required this.title, required this.subtitle}) : super(key: key);

  @override
  State<DolbyTitle> createState() => _DolbyTitleState();
}

class _DolbyTitleState extends State<DolbyTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              )),
        ],
      ),
    );
  }
}
