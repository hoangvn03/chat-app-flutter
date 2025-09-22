import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/auth/login/bloc/login_event.dart';
import 'package:chat_app/main/ui/auth/login/bloc/login_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../networks/api_util.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInit()) {
    on<Login>(_onSignUpButtonPressed);
  }

  Future<void> _onSignUpButtonPressed(
    Login event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      var data = {'username': event.username, 'password': event.password};
      var url = ApiEndPoints.SIGNUP;
      print(url);
      print(data);
      final response = await ApiUtil.post(url:url, data:data);
      if (response['status_code'] == 200) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure());
      }
    } catch (e) {
      emit(LoginFailure());
    }
  }
}
