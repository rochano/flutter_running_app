class User {
  String email;
  String password;
  String firstName;
  String lastName;

  User({this.email, this.password, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
      };
}
