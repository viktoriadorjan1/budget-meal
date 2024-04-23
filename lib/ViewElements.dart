import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RecipeBook/RecipeBookModel.dart';

double getScreenWidth() {
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  Size size = view.physicalSize / view.devicePixelRatio;
  return size.width;
}

double getScreenHeight() {
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  Size size = view.physicalSize / view.devicePixelRatio;
  return size.height;
}


Widget TitleBar(String title) {
  return Container(
    alignment: Alignment.topLeft,
    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
    width: getScreenWidth() * 0.6,
    decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF26BDC6), Color(0xFF40EB85)]
        ),
        border: Border.all(color: const Color(0xFF26BDC6), width: 5),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))
    ),
    child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
  );
}

Widget MyListTile(String title) {
  return Container(
      width: getScreenWidth() * 0.8,
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
      decoration: BoxDecoration(
          color: const Color(0xFFF3F9F6),
          border: Border.all(color: const Color(0xFF26BDC6), width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Text(title, style: const TextStyle(color: Color(0xFF26BDC6), fontWeight: FontWeight.bold, fontSize: 18))
  );
}

Widget AddButton(String title) {
  return ElevatedButton(onPressed: () {},
    child: Text(title),
  );
}