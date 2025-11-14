import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_event.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import '../../../networks/api_util.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>(_loadRequest);
    on<LoadProfileUserContact>(_loadProfileUserContact);
    on<ClearStrogeUser>(_clearUser);
    on<LoadConveration>(_loadConverationUserContact);
  }
  UserModel user = UserModel(id: 999);
  bool isCurrientUser = true;

  Future<void> _clearUser(
    ClearStrogeUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final token = await AppStorage.getToken();
      var url = ApiEndPoints.SIGNIN;
      var data = {'token': token};
      final response = await ApiUtil.post(url: url, data: data);
      if (response['message'] == 'Logout successful') {
        final res = response['message'];
        await AppStorage.clearUser();
      }
    } catch (e) {
      emit(ProfileFailure());
    }
  }

  Future<void> _loadRequest(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      var url = ApiEndPoints.PROFILE;
      ApiResponse res = await ApiUtil.get(url);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']['user']);
        print(user.bio);
      
        emit(ProfileSuccess(reels: [], posts: [], user: user));
      }
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }

  Future<void> _loadProfileUserContact(
    LoadProfileUserContact event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      var url = '${ApiEndPoints.USERS}/${event.id}';
      ApiResponse res = await ApiUtil.get(url);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']['user']);
        final converationId = res.body['data']['conversation_id'];
        emit(ProfileSuccess(user: user, conversationId: converationId));
      }
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }

  Future<void> _loadConverationUserContact(
    LoadConveration event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state as ProfileSuccess;

    try {
      var url = '${ApiEndPoints.CONVERATIONS}/${event.id}';
      ApiResponse res = await ApiUtil.get(url);
      if (res.statusCode == 200) {
        final converation = Conversation.fromJson(
          res.body['data']['conversation'],
        );
        emit(currentState.copyWith(conversation: converation));
      }
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }
}
