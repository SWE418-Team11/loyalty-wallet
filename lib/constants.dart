import 'package:flutter/material.dart';

const kMainColor = Color(0xff00af91);
const kOrangeColor = Color(0xffF58634);

const MaterialColor kMainMaterialColor =
    MaterialColor(0xFF00af91, _mainMaterialColor);
const Map<int, Color> _mainMaterialColor = {
  50: Color.fromRGBO(0, 175, 145, .1),
  100: Color.fromRGBO(0, 175, 145, .2),
  200: Color.fromRGBO(0, 175, 145, .3),
  300: Color.fromRGBO(0, 175, 145, .4),
  400: Color.fromRGBO(0, 175, 145, .5),
  500: Color.fromRGBO(0, 175, 145, .6),
  600: Color.fromRGBO(0, 175, 145, .7),
  700: Color.fromRGBO(0, 175, 145, .8),
  800: Color.fromRGBO(0, 175, 145, .9),
  900: Color.fromRGBO(0, 175, 145, 1),
};

InputDecoration kTexFieldDecoration = const InputDecoration(
  hintText: "hint",
  hintStyle: TextStyle(color: Colors.black38),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black38, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
