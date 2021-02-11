class Schedule {
  String id;
  String nameCustomer;
  String employeeId;
  DateTime date;
  String thumbnailCustomer;
  String nameEmployee;
  int hour;
  bool concluded;
  String customerId;

  Schedule(
      {String nameCustomer,
      String employeeId,
      DateTime date,
      int hour,
      bool concluded,
      String thumbnailCustomer,
      String nameEmployee,
      String id,
      String customerId}) {
    this.nameCustomer = nameCustomer;
    this.employeeId = employeeId;
    this.date = date;
    this.hour = hour;
    this.concluded = concluded;
    this.thumbnailCustomer = thumbnailCustomer;
    this.nameEmployee = nameEmployee;
    this.id = id;
    this.customerId = customerId;
  }

  toMap() {
    return {
      'nameCustomer': this.nameCustomer,
      'employeeId': this.employeeId,
      'date': this.date,
      'hour': this.hour,
      'concluded': this.concluded,
      'thumbnailCustomer': this.thumbnailCustomer,
      'nameEmployee': this.nameEmployee,
      'customerId': this.customerId
    };
  }
}
