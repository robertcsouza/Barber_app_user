import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/material.dart';

Widget inputText(
    {@required TextEditingController controller,
    @required String hint,
    @required bool obscure}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
    child: Container(
      child: TextField(
        obscureText: obscure,
        controller: controller,
        cursorColor: light,
        style: TextStyle(color: light, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: light, fontSize: 14),
          fillColor: bgColorLight,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          focusColor: bgColorLight,
          focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: bgColorLight),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              )),
          border: new OutlineInputBorder(
              borderSide: BorderSide(color: bgColorLight),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              )),
        ),
      ),
    ),
  );
}
