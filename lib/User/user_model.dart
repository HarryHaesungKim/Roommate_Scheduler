class UserModel {
  final String? id;
  final String userName;
  final String email;
  final String password;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.userName,
  });

  toJson() {
    return {
      "UserName": userName,
      "Email": email,
      "Password": password,
    };
  }
}
