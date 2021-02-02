import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter/material.dart';

BottomNavigationBar navigation({index, ontapped, context}) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        title: Text('Meus Agendamentos'),
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
          Navigator.pushReplacementNamed(context, 'barber/scheduling');
          break;

        case 1:
          Navigator.pushReplacementNamed(
              context, 'barber/scheduling/selectUser');
          break;

        case 2:
          Navigator.pushReplacementNamed(context, 'barber/profile');
          break;
      }
    },
    selectedItemColor: accentColor,
  );
}
