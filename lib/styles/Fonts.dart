import 'package:flutter/material.dart';

TextStyle titleBold({@required Color color}) {
  return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold);
}

TextStyle title({@required Color color}) {
  return TextStyle(fontSize: 15, color: color, fontWeight: FontWeight.normal);
}

TextStyle subtitle({@required Color color}) {
  return TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color);
}
