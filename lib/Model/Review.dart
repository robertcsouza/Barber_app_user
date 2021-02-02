import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  double stars;
  String comment;
  DateTime date;

  Review({double stars, String comment, DateTime date}) {
    this.stars = stars;
    this.comment = comment;
    this.date = date;
  }

  toMap() {
    return {'stars': this.stars, 'comment': this.comment, 'date': this.date};
  }

  getStars() {
    return this.stars;
  }

  setStars(stars) {
    this.stars = stars;
  }

  getComment() {
    return this.comment;
  }

  setComment(comment) {
    this.comment = comment;
  }
}
