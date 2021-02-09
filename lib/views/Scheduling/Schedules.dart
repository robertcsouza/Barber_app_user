import 'package:barber_app_user/Helper/ConvertDate.dart';
import 'package:barber_app_user/Model/Schedule.dart';
import 'package:barber_app_user/components/AppBar.dart';
import 'package:barber_app_user/components/BottomNavigation.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Schedules extends StatefulWidget {
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  _initStream() {
    return db
        .collection('schedules')
        .where('customerId', isEqualTo: auth.currentUser.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: 'Agendamentos'),
      bottomNavigationBar: navigation(context: context, index: 0),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: StreamBuilder(
            stream: _initStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                easyLoading();
                return SizedBox();
              } else {
                Future.delayed(Duration(seconds: 1), () {
                  EasyLoading.dismiss();
                });
                List<QueryDocumentSnapshot> documents =
                    snapshot.data.docs.toList();
                List<Schedule> schedules = List();
                for (var item in documents) {
                  Schedule sche = Schedule(
                      concluded: item['concluded'],
                      date: item['date'].toDate(),
                      employeeId: item['employeeId'],
                      hour: item['hour'],
                      id: item.id,
                      nameCustomer: item['nameCustomer'],
                      nameEmployee: item['nameEmployee'],
                      thumbnailCustomer: item['thumbnailCustomer']);

                  schedules.add(sche);
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text('nao há dados'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      return _listTile(schedules[index]);
                    },
                  );
                }
              }
            },
          )),
    );
  }

  Widget _listTile(Schedule schedule) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: bgColorLight,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.asset(
                    'images/skull_logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Text(
              'Navalha Barbearia',
              style: TextStyle(
                  fontSize: 18, color: light, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Barbeiro: ${schedule.nameEmployee}",
                style: TextStyle(
                    fontSize: 16, color: light, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              " ${dateConvert(schedule.date, '-')} : 0${schedule.hour}:00",
              style: TextStyle(
                  fontSize: 16, color: light, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.red,
                  child: Container(
                    width: 200,
                    child: Center(child: Text("Cancelar Agendamento")),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('deletar Agendamento'),
                          content: Text(
                              'Tem certeza que deseja deletar Agendamento ?'),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                },
                                child: Text('Não')),
                            FlatButton(
                              onPressed: () async {},
                              child: Text('Sim'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0))),
            ),
          ],
        ),
      ),
    );
  }
}
