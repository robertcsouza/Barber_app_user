import 'package:barber_app_user/Model/Barber.dart';
import 'package:barber_app_user/components/AppBar.dart';
import 'package:barber_app_user/components/CircleName.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/styles/Fonts.dart';
import 'package:barber_app_user/views/Gallery/Gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Scheduling extends StatefulWidget {
  @override
  _SchedulingState createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<NetworkImage> carouselList;
  Future barbers;

  _getCarousel() async {
    List<NetworkImage> tmp = List();
    var documents = await db.collection('carrousel').get();

    for (var item in documents.docs) {
      tmp.add(NetworkImage(item.data()['url']));
    }

    setState(() {
      carouselList = tmp;
    });
  }

  Future _getBarbers() {
    return db.collection('employee').where('enabled', isEqualTo: true).get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCarousel();
    barbers = _getBarbers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar(title: 'Navalha Barbearia'),
        body: Column(
          children: <Widget>[
            // construct the profile details widget here
            carouselList != null
                ? _carrousel()
                : Center(
                    child: Container(
                        color: bgColor,
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Container(
                            width: 48,
                            height: 48,
                            child: CircularProgressIndicator(),
                          ),
                        )),
                  ),
            // the tab bar with two items
            SizedBox(
              height: 50,
              child: AppBar(
                elevation: 8,
                backgroundColor: bgColor,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      text: 'Barbeiros',
                    ),
                    Tab(
                      text: 'Galeria',
                    ),
                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  Container(color: bgColor, child: _listBabrbers()),

                  // second tab bar viiew widget
                  Gallery(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _carrousel() {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width,
        child: Carousel(
          boxFit: BoxFit.cover,
          autoplay: false,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 6.0,
          dotIncreasedColor: accentColor,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: true,
          indicatorBgPadding: 7.0,
          images: carouselList,
        ),
      ),
    );
  }

  _listBabrbers() {
    return FutureBuilder(
      future: barbers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          easyLoading();
          return SizedBox();
        } else {
          EasyLoading.dismiss();
          List<DocumentSnapshot> documentsSnapshot =
              snapshot.data.docs.toList();
          List<Barber> barbers = List();
          if (barbers != null) barbers.clear();
          for (var item in documentsSnapshot) {
            Barber b = Barber(
                uid: item.id,
                email: item.data()['email'],
                enabled: item.data()['enabled'],
                imagePath: item.data()['thumbnail'],
                nome: item.data()['nome']);
            barbers.add(b);
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: barbers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: accentColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: _image(
                              urlImage: barbers[index].imagePath,
                              name: barbers[index].nome),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              barbers[index].nome,
                              style: title(color: light),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _image({urlImage, name}) {
    return Container(
        width: 60,
        height: 60,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return CircularProgressIndicator();
                },
                imageUrl: urlImage,
                errorWidget: (context, url, error) {
                  return circleNamed(name);
                })));
  }
}
