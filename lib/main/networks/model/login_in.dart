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