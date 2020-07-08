class User {
  String name, email, password, type, avatar;

  User(this.name, this.email, this.password, this.type, this.avatar);

  @override
  String toString() {
    return 'User{name: $name, email: $email, password: $password, type: $type, avatar: $avatar}';
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "type": type,
      "avatar": avatar
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    this.name = map["name"];
    this.email = map["email"];
    this.password = map["password"];
    this.type = map["type"];
    this.avatar = map["avatar"];
  }
}
