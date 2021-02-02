class Employee {
  String nome;
  String uid;
  String email;
  String password;
  String imagePath;
  bool   enabled;

  Employee(
      {String nome,
      String email,
      String password,
      String imagePath,
      bool enabled,
      String uid}) {
    this.nome = nome;
    this.email = email;
    this.password = password;
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

  Map toMapLogin() {
    Map<String, dynamic> map = {'email': this.email, 'password': this.password};

    return map;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'nome': this.nome,
      'email': this.email,
      'thumbnail': this.imagePath
    };
    return map;
  }
}
