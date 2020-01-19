import 'package:flutter/material.dart';

class MyStyle {
  Color textcolor = Color.fromARGB(0xff, 0x00, 0x68, 0x76);
  Color mainColor = Color.fromARGB(0xff, 0x56, 0xc7, 0xd6);
  Color barColor = Color.fromARGB(0xff, 0x00, 0x96, 0xa5);

  TextStyle h1Text = TextStyle(
      fontFamily: 'Itim',
      color: Color.fromARGB(0xff, 0x00, 0x68, 0x76),
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 30.0);

  TextStyle h2Text = TextStyle(
      fontFamily: 'Itim',
      color: Color.fromARGB(0xff, 0x00, 0x68, 0x76),
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontSize: 18.0);

  MyStyle();
}
