class Barber {
  String nome;
  String uid;
  String email;
  String imagePath;
  bool enabled;

  Barber(
      {String nome, String email, String imagePath, bool enabled, String uid}) {
    this.nome = nome;
    this.email = email;
    this.imagePath = imagePath;
    this.enabled = enabled;
    this.uid = uid;
  }

  void setImagePath(String imagePath) {
    this.imagePath = imagePath;
  }

  String getUid() {
    return this.uid;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'nome': this.nome,
      'email': this.email,
      'thumbnail': this.imagePath,
      'employeeId': this.uid
    };
    return map;
  }
}
