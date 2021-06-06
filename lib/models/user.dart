class User {
  int userId;
  String email;
  String password;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  double weight;
  double height;
  String image;

  User(
      {this.userId,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.gender,
      this.birthDate,
      this.weight,
      this.height,
      this.image});

  DateTime getBirthDate() {
    int y = int.parse(birthDate.substring(0, 4));
    int m = int.parse(birthDate.substring(4, 6));
    int d = int.parse(birthDate.substring(6, 8));
    return new DateTime(y, m, d);
  }

  bool isImageAsUrl() {
    return image != null && image.startsWith("http");
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: int.parse(json["userId"].toString()),
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        gender: json["gender"],
        birthDate: json["birthDate"],
        weight: double.parse(json["weight"].toString()),
        height: double.parse(json["height"].toString()),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "birthDate": birthDate,
        "weight": weight,
        "height": height,
        "image": image,
      };

  void parse(User user) => {
        firstName = user.firstName,
        lastName = user.lastName,
        gender = user.gender,
        birthDate = user.birthDate,
        weight = user.weight,
        height = user.height,
        image = user.image,
      };
}
