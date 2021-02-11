import 'dart:io';

import 'package:barber_app_user/components/AppBar.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  ImagePicker imagePicker = ImagePicker();
  File imageGet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
        child: StreamBuilder(
          stream: db.collection('gallery').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              easyLoading();
              return SizedBox();
            } else {
              EasyLoading.dismiss();
              QuerySnapshot querySnapshot = snapshot.data;
              List<DocumentSnapshot> documentsSnapshots =
                  querySnapshot.docs.toList();

              return gallery(documentsSnapshots);
            }
          },
        ),
      ),
    );
  }

  Widget gallery(List<DocumentSnapshot> documentsSnapshots) {
    if (documentsSnapshots.isEmpty) {
      return Center(child: Text('nenhuma foto disponivel!'));
    } else {
      return GridView.count(
          crossAxisCount: 3,
          children: List.generate(documentsSnapshots.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/image/detail',
                      arguments: documentsSnapshots[index].data()['url']);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return SizedBox();
                        },
                        imageUrl: documentsSnapshots[index].data()['url'],
                        errorWidget: (context, url, error) {
                          return SizedBox();
                        }),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: bgColorLight,
                  ),
                ),
              ),
            );
          }));
    }
  }
}
