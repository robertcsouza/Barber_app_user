import 'package:barber_app_user/Helper/ConvertDate.dart';
import 'package:barber_app_user/Model/Barber.dart';
import 'package:barber_app_user/Model/Employee.dart';
import 'package:barber_app_user/Model/Notify.dart';
import 'package:barber_app_user/Model/Schedule.dart';
import 'package:barber_app_user/components/Buttons.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarBarber extends StatefulWidget {
  @override
  _CalendarBarberState createState() => _CalendarBarberState();
  String userName;
  Barber barber;

  CalendarBarber({Barber barber}) {
    this.barber = barber;
  }
}

class _CalendarBarberState extends State<CalendarBarber> {
  CalendarController _calendarController = CalendarController();
  // sliding_up_painel
  // final double _initFabHeight = 120.0;
  // double _fabHeight;
  //double _panelHeightOpen;
  // double _panelHeightClosed = 95.0;

  String username;
  String thumbnailUser;
  Barber barber;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Color todayColor = accentColor;
  int indexColor;
  //info to save
  int weekDay;
  DateTime daySelected;
  int hourSelected;

  DateTime holiday;
  var daysWeek;
  var hours;
  var avalible = [];

  bool isHoliday = false;

  @override
  void initState() {
    super.initState();
    username = 'teste';
    barber = widget.barber;
    _getUser();
    init();

    //DateTime now = DateTime.now();
  }

  _getUser() async {
    var user = await db.collection('customers').doc(auth.currentUser.uid).get();
    username = user.data()['nome'];
    thumbnailUser = user.data()['thumbnail'];
  }

  void init() async {
    DateTime now = dateUtc(DateTime.now(), '-');
    weekDay = now.weekday;
    setState(() {
      daySelected = now;
      holiday = now;
    });
    await _isHoliday(holi: now);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _calendarController.dispose();
    super.dispose();
  }

  _schedule() async {
    if (daysWeek[weekDay - 1] == true) {
      DateTime now = dateUtc(DateTime.now(), '-');
      if (daySelected.isBefore(now)) {
        EasyLoading.showError('Data anterior ao dia de Atual!');
      } else if (hourSelected != null) {
        easyLoading();
        var isEmpty = await _confirmIsEmpty();

        if (isEmpty) {
          Schedule schedule = Schedule(
              date: daySelected,
              hour: hourSelected,
              employeeId: barber.uid,
              nameCustomer: username,
              thumbnailCustomer: thumbnailUser,
              concluded: false,
              customerId: auth.currentUser.uid,
              nameEmployee: barber.nome);
          Notify notification = Notify(
              customerName: username,
              date: daySelected,
              type: 'Agendamento',
              hour: hourSelected);
          db.collection('schedules').add(schedule.toMap()).then((value) {
            db
                .collection('notifications-admin')
                .add(notification.toMap())
                .then((value) {
              db
                  .collection('notifications-${barber.uid}')
                  .add(notification.toMap())
                  .then((value) {
                EasyLoading.showSuccess('Agendamento salvo com sucesso!');
                Navigator.pushReplacementNamed(context, '/schedules');
              });
            });
          }).catchError((error) {
            EasyLoading.showSuccess(
                'hove algum problema por favor tente novamente !');
          });
        } else {
          EasyLoading.showError('Horario indisponivel!');
        }
      } else {
        EasyLoading.showError('Selcione um horário');
      }
    } else {
      EasyLoading.showError('Dia da semana nao disponivel!');
    }
  }

  _getConfigs() async {
    var res = await db.collection('configurations').doc('config').get();
    setState(() {
      daysWeek = res.data()['daysWeek'];
      hours = res.data()['hours'];
    });
  }

  _confirmIsEmpty() async {
    await _getConfigs();
    var res = await db
        .collection('schedules')
        .where('employeeId', isEqualTo: barber.uid)
        .where('date', isEqualTo: daySelected)
        .where('hour', isEqualTo: hourSelected)
        .get();
    List<DocumentSnapshot> documentsSnapshots = res.docs.toList();

    return documentsSnapshots.isEmpty;
  }

  _getschedules({DateTime date}) async {
    await _getConfigs();
    var res = await db
        .collection('schedules')
        .where('employeeId', isEqualTo: barber.uid)
        .where('date', isEqualTo: daySelected)
        .get();
    List<DocumentSnapshot> documentsSnapshots = res.docs.toList();

    documentsSnapshots.forEach((element) {
      hours[element['hour']] = false;
    });
    setState(() {
      avalible = hours;
    });
    Future.delayed(Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }

  _isHoliday({DateTime holi}) async {
    easyLoading();
    await db
        .collection('holidays')
        .where('date', isEqualTo: holi)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty == true) {
        setState(() {
          isHoliday = true;
        });
        EasyLoading.dismiss();
      } else {
        isHoliday = false;
        await _getschedules();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar'),
        backgroundColor: bgColorLight,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: bgColorLight,
        child: SlidingSheet(
          minHeight: 50,
          color: Color(0xFFf5f5f5),
          elevation: 8,
          cornerRadius: 16,
          headerBuilder: (context, state) => _headerSlide(),
          snapSpec: const SnapSpec(
            // Enable snapping. This is true by default.
            snap: true,
            // Set custom snapping points.
            snappings: [0.25, 0.7, 1.0],
            // Define to what the snappings relate to. In this case,
            // the total available space that the sheet can expand to.
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          // The body widget will be displayed under the SlidingSheet
          // and a parallax effect can be applied to it.
          body: _calendar(),
          builder: (context, state) {
            // This is the content of the sheet that will get
            // scrolled, if the content is bigger than the available
            // height of the sheet.
            if (isHoliday == true) {
              return Center(
                child: Text('hoje nao abriremos'),
              );
            } else {
              return _bodySliding();
            }
          },
        ),
      ),
    );
  }

  _bodySliding() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.60,
            child: ListView.builder(
              itemCount: avalible.length,
              itemBuilder: (context, index) {
                if (avalible == null) {
                  return Center(
                    child: Text('horarios indisponivies'),
                  );
                } else if (avalible[index] == true) {
                  return _listTile(enable: true, index: index);
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: btPrimary(
                call: () {
                  _schedule();
                },
                lable: 'Agendar',
                context: context),
          )
        ],
      ),
    );
  }

  _calendar() {
    return Container(
      color: bgColorLight,
      child: TableCalendar(
        availableGestures: AvailableGestures.horizontalSwipe,
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(color: Colors.white),
          formatButtonVisible: false,
          leftChevronIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 14,
          ),
          rightChevronIcon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 14,
          ),
          centerHeaderTitle: true,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.white),
            weekdayStyle: TextStyle(color: Colors.white)),
        calendarStyle: CalendarStyle(
          selectedColor: calendarSelected,
          todayColor: todayColor,
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.white),
        ),
        calendarController: _calendarController,
        onDaySelected: (day, events, holidays) async {
          //print(day);
          DateTime dayTime = dateUtc(day, '-');
          setState(() {
            hourSelected = null;
            holiday = dayTime;
            daySelected = dayTime;
            weekDay = dayTime.weekday;
            todayColor = Colors.transparent;
            indexColor = null;
          });
          await _isHoliday(holi: dayTime);
        },
      ),
    );
  }

  Widget _listTile({
    int index,
    bool enable,
  }) {
    return Card(
      //color: indexColor == index ? bgColorLight : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () async {
            setState(() {
              hourSelected = index;
              indexColor = index;
            });
          },
          enabled: enable,
          leading: indexColor == index
              ? Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
              : SizedBox(),
          title: Text(
            'Disponivel',
            style: TextStyle(),
            // color: indexColor == index ? Colors.white : Colors.black87),
          ),
          trailing: Text(
            '$index:00',
            style: TextStyle(
              fontSize: 16,
            ),
            // color: indexColor == index ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _headerSlide() {
    return Material(
      elevation: 4,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 2,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
