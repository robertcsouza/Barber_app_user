class Notify {
  String type;
  String customerName;
  DateTime date;
  int hour;

  Notify({String type, String customerName, DateTime date, int hour}) {
    this.type = type;
    this.customerName = customerName;
    this.date = date;
    this.hour = hour;
  }

  toMap() {
    return {
      'type': this.type,
      'customerName': this.customerName,
      'date': this.date,
      'hour': this.hour
    };
  }
}
