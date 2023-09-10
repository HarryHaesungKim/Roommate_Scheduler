class userModel {
  String? username;
  String? email;
  String? firstName;
  String? id;
  String? lastName;
  String? phoneNumber;

  ///
  /// userModel Constructor
  ///
  userModel({
    this.email,
    this.username,
    this.firstName,
    this.id,
    this.lastName,
  });

  ///
  /// This method creates a userModel object from a JSON object
  ///
  userModel.fromJson(Map<String, dynamic> json) {
    email = json['email'].toString();
    username = json['username'].toString();
    firstName = json['firstName'].toString();
    id = json['id'].toString();
    lastName = json['lastName'].toString();
  }


  ///
  /// This method converts a userModel object to a JSON object
  ///
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['email'] = this.email;
    data['userName'] = this.username;
    data['firstName'] = this.firstName;
    data['id'] = this.id;
    data['lastName'] = this.lastName;

    return data;
  }
}