import 'package:barber_app_user/Model/Customer.dart';
import 'package:barber_app_user/components/Buttons.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/components/ToastShow.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_app_user/components/Input.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  _createUser(
      {@required name,
      @required email,
      @required password,
      @required repeatPassword}) {
    if (name != '' &&
        email != '' &&
        password != '' &&
        password == repeatPassword) {
      EasyLoading.show(
        status: 'Carregando',
        maskType: EasyLoadingMaskType.black,
      );
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Customer user =
            Customer(nome: name, email: value.user.email, uid: value.user.uid);
        db
            .collection('customers')
            .doc(user.uid)
            .set(user.toMap())
            .then((value) {
          EasyLoading.showSuccess('ok! vamos Continuar');
          Navigator.pushReplacementNamed(context, '/register/image',
              arguments: user);
        });
      }).catchError((error) {
        print(error.toString());
        EasyLoading.showError(
            'Nao foi possivel realizar o cadastro! confira os campos e tente novamente');
      });
    } else {
      ToastShow.show(
          content: 'Por favor Preencha os campos corretamente',
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 64.0),
                  child: Container(
                    width: 220,
                    height: 220,
                    child: Image.asset('images/skull_logo.png'),
                  ),
                ),
                inputText(controller: name, hint: 'Nome', obscure: false),
                inputText(controller: email, hint: 'Email', obscure: false),
                inputText(controller: password, hint: 'Senha', obscure: true),
                inputText(
                    controller: repeatPassword,
                    hint: 'Repetir Senha',
                    obscure: true),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: btPrimary(
                      call: () {
                        _createUser(
                            name: name.text,
                            email: email.text,
                            password: password.text,
                            repeatPassword: repeatPassword.text);
                      },
                      lable: 'Cadastrar',
                      context: context),
                )
              ],
            ),
          ),
        ));
  }
}
