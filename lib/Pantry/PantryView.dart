import 'package:flutter/material.dart';
import '../ViewElements.dart';

Widget Pantry() {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 50),
        TitleBar("My pantry"),
        ElevatedButton(
          onPressed: () {
          },
          child: const Text("Generate pantry"),
        )
      ],
    ),
  );
}