import 'package:barber_app_user/components/Buttons.dart';
import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:barber_app_user/components/Input.dart';
import 'package:barber_app_user/components/ToastShow.dart';
import 'package:barber_app_user/config/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'styles/Colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      initialRoute: '/',
      routes: routes(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool status = false;
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  FirebaseFirestore fb = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
    if (auth.currentUser != null) {
      Future(() {
        Navigator.pushNamed(context, '/schedules');
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: bgColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Container(
                  width: 250,
                  height: 250,
                  child: Image.asset('images/skull_logo.png'),
                ),
              ),
              inputText(controller: email, hint: 'Email', obscure: false),
              inputText(controller: senha, hint: 'Senha', obscure: true),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: btPrimary(
                    call: () {
                      //_loadingTest();
                      _login(email: email.text, password: senha.text);
                    },
                    lable: 'Entrar',
                    context: context),
              ),
              btSecondary(
                  call: () {
                    _register();
                  },
                  lable: 'Cadastre-se',
                  context: context),
              btFlat(
                  call: () {
                    Navigator.pushNamed(context, 'barber/scheduling');
                  },
                  lable: 'Esqueci minha senha',
                  context: context),
            ],
          ),
        ),
      ),
    );
  }

  _login({@required String email, @required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      ToastShow.show(
          content: 'Por favor preencha todos os campos', context: context);
    } else {
      easyLoading();

      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        Navigator.pushNamed(context, '/schedules');
        EasyLoading.dismiss();
      }).catchError((error) {
        print(error.toString());
        EasyLoading.showError('Não foi possivel fazer o Login');
      });
    }
  }

  _register() {
    Navigator.pushNamed(context, '/register');
  }
}
