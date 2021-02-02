import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/cupertino.dart';

Widget emptyFolder({@required String content}) {
  return Container(
      width: 300,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/emptyNoBg.png'),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: light,
            ),
          )
        ],
      ));
}
