import 'package:flutter/material.dart';
import '../ViewElements.dart';

Widget Shopping() {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 50),
        TitleBar("My shopping list"),
        ElevatedButton(
          onPressed: () {
          },
          child: const Text("Create shopping list"),
        )
      ],
    ),
  );
}