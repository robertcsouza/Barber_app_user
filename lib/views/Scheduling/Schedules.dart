import 'package:barber_app_user/Helper/ConvertDate.dart';
import 'package:barber_app_user/Model/Review.dart';
import 'package:barber_app_user/Model/Schedule.dart';
import 'package:barber_app_user/components/AppBar.dart';
import 'package:barber_app_user/components/BottomNavigation.dart';
import 'package:barber_app_user/components/Buttons.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/components/NoScheduling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:barber_app_user/Model/Notify.dart';

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
        .where('concluded', isEqualTo: false)
        .snapshots();
  }

  _getRating() async {
    var user = await db.collection('customers').doc(auth.currentUser.uid).get();
    print(user.data()['ratingPending']);
    if (user.data()['ratingPending'] == true) {
      _showRating();
    }
  }

  _saveReview({double stars, String comment}) {
    easyLoading();
    DateTime now = DateTime.now();
    Review review = Review(stars: stars, comment: comment, date: now);
    db.collection('reviwes').add(review.toMap()).then((value) async {
      await _dismissRating();
      EasyLoading.showSuccess('Obrigado por participar');
    });
  }

  _dismissRating() {
    db
        .collection('customers')
        .doc(auth.currentUser.uid)
        .update({'ratingPending': false}).then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRating();
  }

  _showRating() {
    double stars = 0;
    double rating = 0;
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: bgColorLight,
          content: Container(
            height: MediaQuery.of(context).size.height * .60,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      width: 200,
                      height: 200,
                      child: Image.asset('images/skull_logo.png')),
                  Text(
                    'Como foi sua experiencia ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: light,
                        fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Por favor conte nos como foi seu atendimento!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: light,
                          fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SmoothStarRating(
                        allowHalfRating: false,
                        onRated: (v) {
                          stars = v;
                        },
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        isReadOnly: false,
                        color: accentColor,
                        borderColor: accentColor,
                        spacing: 0.0),
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 2,
                    maxLength: 200,
                    style: TextStyle(color: light),
                    decoration: new InputDecoration(
                        counterStyle: TextStyle(color: light),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: accentColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: accentColor, width: 1.0),
                        ),
                        hintText: 'Seu comentario',
                        hintStyle: TextStyle(color: light)),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: btFlat(
                        call: () {
                          _dismissRating();
                        },
                        lable: 'Não Obrigado!',
                        context: context),
                  ),
                  Container(
                    child: RaisedButton(
                      color: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      onPressed: () {
                        _saveReview(stars: stars, comment: controller.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 32, right: 32),
                        child: Text(
                          'Enviar',
                          style: TextStyle(
                            color: light,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
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
                  if (schedules.length <= 0) {
                    return noScheduling();
                  } else {
                    return ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        return _listTile(schedules[index]);
                      },
                    );
                  }
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
                              onPressed: () async {
                                Notify notify = Notify(
                                    customerName: schedule.nameCustomer,
                                    date: schedule.date,
                                    hour: schedule.hour,
                                    type: 'Cancelamento');

                                db
                                    .collection('schedules')
                                    .doc(schedule.id)
                                    .delete()
                                    .then((value) {
                                  db
                                      .collection('notifications-admin')
                                      .add(notify.toMap())
                                      .then((value) {
                                    db
                                        .collection(
                                            'notifications-${schedule.employeeId}')
                                        .add(notify.toMap())
                                        .then((value) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    });
                                  });
                                });
                              },
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
