import 'package:chat_app/main/networks/model/user.dart';

class LoginInModel {
  String? token;
  UserModel? userModel;
  LoginInModel({this.token,this.userModel});

  factory LoginInModel.fromJson(Map<String, dynamic> json) {
    return LoginInModel(
      token: json['token'],
      userModel: UserModel.fromJson(json['user'])
    );
  }
}
class RegisterData {
  UserModel? user;
  String? token;
  String? expiresIn;

  RegisterData({this.user, this.token, this.expiresIn});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'],
      expiresIn: json['expires_in'], // Mapping key JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token,
      'expires_in': expiresIn,
    };
  }
}