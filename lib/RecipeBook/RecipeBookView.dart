import 'package:flutter/material.dart';
import '../ViewElements.dart';

Widget Recipes() {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 50),
        TitleBar("My recipes"),
        Expanded(child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
             const ExpansionTile(title: Text("Category 1"), children: <Widget>[
               ListTile(title: Text("expanded"))
             ]),
              Container(height: 50, color: Colors.amber, child: const Text("Category 1")),
              Container(height: 50, color: Colors.amber, child: const Text("Category 2")),
              Container(height: 50, color: Colors.amber, child: const Text("Category 3"))
            ]
        )),
      ],
    ),
  );
}