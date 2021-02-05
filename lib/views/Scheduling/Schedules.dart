import 'package:barber_app_user/components/AppBar.dart';
import 'package:barber_app_user/components/BottomNavigation.dart';
import 'package:flutter/material.dart';

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: 'Agendamentos'),
      bottomNavigationBar: navigation(context: context, index: 0),
    );
  }
}
