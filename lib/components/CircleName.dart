import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget circleNamed(@required name) {
  var newName = name.split(' ');
  String firsLetter = 'carregando Nome';
  firsLetter = newName[0][0];

  return Container(
    width: 60,
    height: 60,
    child: Center(
      child: Text(
        firsLetter.toUpperCase() != null ? firsLetter.toUpperCase() : '',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: accentColor,
    ),
  );
}
