// ignore_for_file: camel_case_types, prefer_collection_literals

class userModel {
  int? userid;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? dob;
  String? gender;
  String? imagePath;

  userModel(
      {this.userid,
      this.username,
      this.email,
      this.password,
      this.phone,
      this.dob,
      this.gender,
      this.imagePath});

  userModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'] as int?;
    username = json['username'] as String?;
    email = json['email'] as String?;
    password = json['password'] as String?;
    phone = json['phone'] as String?;
    dob = json['dob'] as String?;
    gender = json['gender'] as String?;
    imagePath = json['imagePath'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userid'] = userid;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['dob'] = dob;
    data['gender'] = gender;
    data['imagePath'] = imagePath;
    return data;
  }
}
