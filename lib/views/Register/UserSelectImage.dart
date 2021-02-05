import 'dart:io';

import 'package:barber_app_user/Model/Customer.dart';
import 'package:barber_app_user/components/AppBar.dart';
import 'package:barber_app_user/components/Buttons.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/components/ToastShow.dart';
import 'package:barber_app_user/components/progress.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:barber_app_user/styles/Fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class UserSelectImage extends StatefulWidget {
  @override
  _UserSelectImageState createState() => _UserSelectImageState();
}

class _UserSelectImageState extends State<UserSelectImage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userName = ' ';
  ImagePicker imagePicker = ImagePicker();
  File tmp;
  File image;
  bool toggle = false;
  bool changed = false;
  bool loading = false;
  String id;
  String urlImage = null;
  String fileName;
  Customer user = null;
  _userSingOut(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut().then((value) {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  _getImage() async {
    final PickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      File img = File(PickedFile.path);

      //await CompressImage.compress(
      //  imageSrc: img.absolute.path, desiredQuality: 40);
      setState(() {
        image = img;
        changed = true;
        fileName = image.path.split('/').last;
      });
      // _uploadImage(fileName: fileName);
    }
  }

  _uploadImage({String fileName}) {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    Reference root = storage.ref();
    Reference arq = root.child('customers').child(fileName);

    if (image != null) {
      easyLoading();
      arq.putFile(image).then((value) async {
        String url = await value.ref.getDownloadURL();
        user.setImagePath(url);
        db
            .collection('customers')
            .doc(user.getUid())
            .update(user.toMap())
            .then((value) {
          EasyLoading.showSuccess('usuario cadastrado! bem vindo');
          Navigator.pushReplacementNamed(context, '/schedules');
        });
      }).catchError((error) {
        ToastShow.show(content: error, context: context);
      });
    }
  }

  _saveUser() {
    if (image != null) {
      _uploadImage(fileName: fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: appbar(title: 'Foto de perfil'),
      body: Container(
        color: bgColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            progress(current: 3, max: 4),
            Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Text(
                'Selecione uma foto para o seu perfil',
                style: title(color: light),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: _image(),
            ),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: btPrimary(
                  call: () {
                    _saveUser();
                  },
                  lable: 'Concluir',
                  context: context),
            )
          ],
        ),
      ),
    );
  }

  Widget _image() {
    if (image != null) {
      return GestureDetector(
        onTap: () => _getImage(),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 100,
              height: 100,
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            )),
      );
    } else {
      return GestureDetector(
        onTap: () => _getImage(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: SizedBox(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.account_circle,
                color: light,
                size: 100,
              ),
            ],
          )),
        ),
      );
    }
  }
}
