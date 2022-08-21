class User {
  int? id;
  String? name;
  // String? image;
  String? email;
  String? token;

  User({this.id, this.name, this.email, this.token});

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['member']['id'],
        name: json['member']['name'],
        // image: json['member']['image'],
        email: json['member']['email'],
        token: json['token']);
  }
}
