import 'package:barber_app_user/styles/Colors.dart';
import 'package:barber_app_user/styles/Fonts.dart';
import 'package:flutter/material.dart';

Widget noScheduling() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'images/agendamento-no-bg.png',
        height: 200,
        width: 200,
      ),
      Text(
        'Você ainda não tem agendamentos',
        style: title(color: light),
      )
    ],
  );
}
