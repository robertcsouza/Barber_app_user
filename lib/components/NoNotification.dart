import 'package:barber_app_user/styles/Colors.dart';
import 'package:barber_app_user/styles/Fonts.dart';
import 'package:flutter/material.dart';

Widget noNotification() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'images/notification-no-bg.png',
        height: 200,
        width: 200,
      ),
      Text(
        'Não há Notificações',
        style: title(color: light),
      )
    ],
  );
}
