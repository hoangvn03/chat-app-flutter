import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<LoadListUser>(_loadListUser);
    on<LoadListReel>(_loadListReel);
    // on<DeletetUser>(_deleteUser);
    // on<UpdateUser>(_updateUser);
  }
  UserModel user = UserModel();
  Future<void> _loadListUser(
    LoadListUser event,
    Emitter<HomeState> emit,
  ) async {
    try {
      var url = ApiEndPoints.USERINFO;
      final response = await ApiUtil.post(url: url);
      if (response['code'] == 0) {
        user = UserModel.fromJson(response['user']);
        emit(HomeSuccess(user: user));
      } else {
        emit(HomeFailure());
      }
    } catch (e) {
      emit(HomeFailure());
    }
    return;
  }

  Future<void> _loadListReel(
    LoadListReel event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final reels = [
        ReelModel(user: UserModel(name: "Hoang")),
        ReelModel(user: UserModel(name: "Tuan Anh")),
      ];
      emit(HomeSuccess(reels: reels));
    } catch (e) {
      emit(HomeFailure());
    }
    return;
  }

  // Future<void> _deleteUser(DeletetUser event, Emitter<HomeState> emit) async {
  //   try {
  //     String url =
  //         '${ApiEndPoints.DELETEUSER}/${event.userId}'; // Assuming userId is passed in the event
  //     final response = await ApiUtil.delete(url);
  //     if (response['status_code'] == 200) {
  //       final List<UserModel> users =
  //           (response['data'] as List)
  //               .map((user) => UserModel.fromJson(user))
  //               .toList();
  //       emit(HomeSuccess(users));
  //     } else {
  //       emit(HomeFailure());
  //     }
  //   } catch (e) {
  //     emit(HomeFailure());
  //   }
  //   return;
  // }

  // Future<void> _updateUser(UpdateUser event, Emitter<HomeState> emit) async {
  //   try {
  //     String url = '${ApiEndPoints.UPDATEUSER}/${event.user.id}';
  //     final data = {
  //       'username': event.user.userName,
  //       'password': event.user.passWord,
  //     };
  //     print('Updating user: $data');
  //     final response = await ApiUtil.put(url, data);
  //     if (response['status_code'] == 200) {
  //       listUser.removeWhere((user) => user.id == event.user.id);
  //       final UserModel user = UserModel.fromJson(response['data']);
  //       listUser.add(user);
  //       emit(HomeSuccess(listUser));
  //     } else {
  //       emit(HomeFailure());
  //     }
  //   } catch (e) {
  //     emit(HomeFailure());
  //   }
  //   return;
  // }
}
