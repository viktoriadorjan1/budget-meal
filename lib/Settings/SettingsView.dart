import 'package:flutter/material.dart';

Widget More() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
          },
          child: const Text("More..."),
        )
      ],
    ),
  );
}