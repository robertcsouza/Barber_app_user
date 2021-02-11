import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/material.dart';

BottomNavigationBar navigation({index, ontapped, context}) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        title: Text('Agendamentos'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        title: Text('Agendar'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text('Perfil'),
      ),
    ],
    currentIndex: index,
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/schedules');
          break;

        case 1:
          Navigator.pushNamed(context, '/scheduling');
          break;

        case 2:
          Navigator.pushReplacementNamed(context, '/perfil');
          break;
      }
    },
    selectedItemColor: accentColor,
  );
}
