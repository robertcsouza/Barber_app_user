import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget btPrimary(
    {@required Function call, @required String lable, @required context}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: RaisedButton(
        color: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: call,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
          child: Text(
            lable,
            style: TextStyle(
              color: light,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget btSecondary(
    {@required Function call, @required String lable, @required context}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: RaisedButton(
          color: bgColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: accentColor)),
          onPressed: call,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16),
            child: Text(
              lable,
              style: TextStyle(
                color: light,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget btFlat(
    {@required Function call, @required String lable, @required context}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: FlatButton(
      child: Text(
        lable,
        style: TextStyle(color: accentColor, fontSize: 14),
      ),
      onPressed: call,
    ),
  );
}
