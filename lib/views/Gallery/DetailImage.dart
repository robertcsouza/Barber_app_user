import 'package:barber_app_user/components/EasyLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photo_view/photo_view.dart';
import 'package:barber_app_user/styles/Colors.dart';

class DetailImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [IconButton(icon: Icon(Icons.share), onPressed: () {})],
            )),
        body: Container(
          color: bgColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
              child: PhotoView(
            backgroundDecoration: BoxDecoration(color: bgColor),
            imageProvider: NetworkImage(args),
            loadingBuilder: (context, event) {
              if (event == null) {
                easyLoading();
                return SizedBox();
              } else {
                EasyLoading.dismiss();
                return SizedBox();
              }
            },
          )),
        ),
      );
    } else {
      easyLoading();
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: bgColor,
        child: SizedBox(),
      );
    }
  }
}
