import 'package:barber_app_user/Model/Review.dart';
import 'package:barber_app_user/components/Buttons.dart';
import 'package:barber_app_user/styles/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'EasyLoading.dart';

class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  _saveReview({double stars, String comment}) {
    easyLoading();
    DateTime now = DateTime.now();
    Review review = Review(stars: stars, comment: comment, date: now);
    db.collection('reviwes').add(review.toMap()).then((value) {
      EasyLoading.showSuccess('Obrigado por participar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
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
                                      borderSide: BorderSide(
                                          color: accentColor, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: accentColor, width: 1.0),
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
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
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
                                    _saveReview(
                                        stars: stars, comment: controller.text);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8,
                                        left: 32,
                                        right: 32),
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
              },
              child: Text('Dialog'),
            )
          ],
        ),
      ),
    );
  }
}
