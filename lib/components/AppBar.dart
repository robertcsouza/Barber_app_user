import 'package:badges/badges.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

AppBar appbar({String title}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title), /*_stream()*/
      ],
    ),
    backgroundColor: bgColor,
  );
}

_stream() {
  print('chamouo stream');
  FirebaseFirestore db = FirebaseFirestore.instance;
  return StreamBuilder(
    stream: db.collection('notifications-admin').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            });
      } else if (snapshot.hasData) {
        QuerySnapshot querySnapshot = snapshot.data;
        List<DocumentSnapshot> documentsSnapshots = querySnapshot.docs.toList();

        if (documentsSnapshots.length <= 0) {
          return IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              });
        } else {
          return Badge(
            badgeContent: Text(documentsSnapshots.length.toString(),
                style: TextStyle(
                  color: light,
                )),
            child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                }),
          );
        }
      } else {
        return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            });
      }
    },
  );
}
