import 'package:chat_app/main/networks/model/user.dart';

abstract class AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  UserModel? user;
  String? message;
  bool hasLocalUser;
  AuthSuccess({this.user, this.message, this.hasLocalUser = false});
}

class AuthFailure extends AuthState {
  final String erroMessage;
  AuthFailure(this.erroMessage);
}

class AuthInit extends AuthState {
  String? erroMessage;
  AuthInit({this.erroMessage});
}
