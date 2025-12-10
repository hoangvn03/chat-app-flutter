import 'package:chat_app/main/networks/model/user.dart';

abstract class AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel? user;
  final String? message;
  final bool hasLocalUser;
  final String? statusUser;
    final List<String> phoneNumbers;

  AuthSuccess({
    this.user,
    this.message,
    this.hasLocalUser = false,
    this.statusUser,
    this.phoneNumbers = const [],
  });

  AuthSuccess copyWith({
    UserModel? user,
    String? message,
    bool? hasLocalUser,
    String? statusUser,
  }) {
    return AuthSuccess(
      user: user ?? this.user,
      message: message ?? this.message,
      hasLocalUser: hasLocalUser ?? this.hasLocalUser,
      statusUser: statusUser ?? this.statusUser,
    );
  }
}

class AuthFailure extends AuthState {
  final String erroMessage;
  AuthFailure(this.erroMessage);
}

class AuthInit extends AuthState {
  String? erroMessage;
  AuthInit({this.erroMessage});
}
