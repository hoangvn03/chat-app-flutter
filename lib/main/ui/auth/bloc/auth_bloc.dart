import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/login_in.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/auth/bloc/auth_event.dart';
import 'package:chat_app/main/ui/auth/bloc/auth_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

//alice@example.com
//password123
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthLoading()) {
    on<Login>(_onSignIn);
    on<Logout>(_signOut);
    on<CheckUser>(_checkRecentUser);
  }

  Future<void> _onSignIn(Login event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var data = {'email': event.username, 'password': event.password};
      var url = ApiEndPoints.SIGNIN;
      ApiResponse res = await ApiUtil.post(url: url, data: data);
      if (res.statusCode == 200) {
        final data = LoginInModel.fromJson(res.body['data']);
        final curUser = data.userModel;
        if (data.token != null) {
          await AppStorage.saveToken(data.token ?? '');
        }
        if (curUser != null) {
          await AppStorage.saveUser(curUser);
          await AppStorage.saveIsLogin(true);
          final tokeSave = await AppStorage.getToken();
          print('TokenSave: $tokeSave');
          emit(AuthSuccess(user: curUser, message: res.body['message']));
        } else {
          emit(AuthFailure(res.body['error']['message']));
        }
      } else {
        emit(AuthInit(erroMessage: res.body['error']['message']));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _checkRecentUser(
    CheckUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await AppStorage.getUser();
      final isLoggin = await AppStorage.getIsLogin();
      if (!isLoggin && user != null) {
        emit(AuthSuccess(user: user, hasLocalUser: true));
      } else {
        emit(AuthInit());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _signOut(Logout event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      final token = await AppStorage.getToken();
      var url = ApiEndPoints.SIGNOUT;
      var data = {'token': token};
      ApiResponse res = await ApiUtil.post(url: url, data: data);
      if (res.statusCode == 200) {
        await AppStorage.saveIsLogin(false);
        emit(AuthSuccess(message: res.body['message']));
      } else {
        emit(
          AuthFailure(
            'Error ${res.statusCode}: ${res.body?['message'] ?? 'Unknown'}',
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
