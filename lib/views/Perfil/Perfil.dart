import 'dart:io';

import 'package:barber_app_user/Model/Customer.dart';
import 'package:barber_app_user/components/BottomNavigation.dart';
import 'package:barber_app_user/components/CircleName.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/components/ToastShow.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  bool toggle = false;
  ImagePicker imagePicker = ImagePicker();
  File tmp;
  File image;
  String notifcacao = 'Desativado';
  bool changed = false;
  bool initial = true;
  TextEditingController nome = TextEditingController();
  TextEditingController nascimento = TextEditingController();
  Customer customer;
  String email = '';
  String urlImage;
  String fileName;

  _getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('notification') == null) {
      await prefs.setBool('notification', false);
    } else if (prefs.get('notification') != null) {
      setState(() {
        toggle = prefs.get('notification');
      });
    }
  }

  _setNotification({@required value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);

    setState(() {
      toggle = value;
    });
  }

  _getImage() async {
    final PickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        image = File(PickedFile.path);
        changed = true;
      }
    });
  }

  _upload() {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (image != null) {
      fileName = image.path.split('/').last;
      Reference root = storage.ref();
      Reference arq = root.child('customers').child(fileName);
      easyLoading();
      arq.putFile(image).then((value) async {
        String url = await value.ref.getDownloadURL();
        customer.setImagePath(url);
        db.collection('customers').doc(customer.uid).update(
            {'nome': nome.text, 'thumbnail': customer.imagePath}).then((value) {
          EasyLoading.showSuccess('atualizado com sucesso');
          setState(() {
            changed = false;
          });
        });
      }).catchError((error) {
        ToastShow.show(content: error, context: context);
      });
    } else {
      db
          .collection('customers')
          .doc(customer.uid)
          .update({'nome': nome.text}).then((value) {
        EasyLoading.showSuccess('atualizado com sucesso');
        setState(() {
          changed = false;
        });
      });
    }
  }

  _getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String userId = auth.currentUser.uid;
    var userinformations = await db.collection('customers').doc(userId).get();
    var user = await userinformations.data();
    customer = Customer(
        nome: user['nome'],
        email: user['email'],
        imagePath: user['thumbnail'],
        uid: userId);

    setState(() {
      nome.text = customer.nome;
      email = customer.email;
      urlImage = customer.imagePath;
    });
  }

  @override
  void initState() {
    _getNotification();
    super.initState();
    nome.text = '';
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'perfil',
            style: TextStyle(color: bgColor),
          ),
        ),
        backgroundColor: light,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return body(constraints);
        },
      ),
      bottomNavigationBar: navigation(index: 2, context: context),
    );
  }

  Widget body(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        color: bgColor,
        child: Column(
          children: [
            Container(
              width: constraints.maxWidth,
              height: 180,
              child: Stack(
                children: [
                  Container(
                    width: constraints.maxWidth,
                    height: 130,
                    color: light,
                  ),
                  Positioned(
                    top: 75,
                    left: 32,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: bgColor),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      width: 100,
                      height: 100,
                      child: _chooseImage(name: nome.text, thumbnail: ''),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _inputNome()),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      email,
                      style: TextStyle(
                          color: light,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                  ),
                  Divider(
                    color: light,
                    height: 32,
                    indent: 32,
                    endIndent: 32,
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: Row(
                      children: [
                        Switch(
                          value: toggle,
                          onChanged: (value) {
                            _setNotification(value: value);
                          },
                          activeColor: accentColorLight,
                          inactiveThumbColor: accentColor,
                          inactiveTrackColor: Colors.grey,
                        ),
                        Text('Noticação ', style: TextStyle(color: light)),
                        Text(
                          notifcacao,
                          style: TextStyle(
                              color: light,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Center(
                              child: Icon(
                            Icons.email,
                            size: 16,
                            color: Colors.white,
                          )),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Email nao Verificado',
                                style: TextStyle(color: light),
                              ),
                            ),
                            FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Verifique seu email',
                                  style: TextStyle(color: accentColor),
                                )),
                            FlatButton(
                                onPressed: () {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  auth.signOut().then((value) =>
                                      Navigator.pushReplacementNamed(
                                          context, '/'));
                                },
                                child: Text(
                                  'Sair',
                                  style: TextStyle(color: accentColor),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  changed ? _btAtualizar() : SizedBox()
                ],
              ),
            ))
          ],
        ));
  }

  Widget _cachedImage({thumbnail, name}) {
    return urlImage == null
        ? Container(
            decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(width: 4, color: bgColor),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            width: 100,
            height: 100,
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ))
        : Container(
            decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(width: 2, color: bgColor),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            width: 100,
            height: 100,
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
                  }),
            ));
  }

  Widget _chooseImage({name, thumbnail}) {
    return GestureDetector(
      onTap: () {
        _getImage();
      },
      child: image == null
          ? _cachedImage(name: name)
          : ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Container(
                width: 100,
                height: 100,
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }

  Widget _inputNome() {
    return TextField(
      controller: nome,
      autofocus: false,
      enabled: true,
      onChanged: (value) {
        setState(() {
          changed = true;
          initial = false;
        });
      },
      style: TextStyle(color: light, fontWeight: FontWeight.bold, fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(border: InputBorder.none),
    );
  }

  Widget _btAtualizar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 64.0, right: 64.0),
          child: RaisedButton(
            color: accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onPressed: () {
              _upload();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8, left: 32, right: 32),
              child: Text(
                'Atualizar',
                style: TextStyle(
                  color: light,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
