import 'dart:ui';
import 'package:flutter/material.dart';

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

class MyListTile extends StatefulWidget {
  const MyListTile({required this.title, super.key});
  final String title;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  int? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getScreenWidth() * 0.8,
        height: getScreenHeight() * 0.08,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F9F6),
          border: Border.all(color: const Color(0xFF26BDC6), width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(color: Color(0xFF26BDC6), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Icon(Icons.more_horiz, color: Color(0xFF26BDC6)),
          ],));
  }
}

Widget AddButton(String title) {
  return ElevatedButton(onPressed: () {},
    child: Text(title),
  );
}