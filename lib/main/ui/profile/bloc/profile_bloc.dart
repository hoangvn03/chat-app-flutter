import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/profile_model.dart';
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
    on<EditProfile>(_editProfile);
    on<LoadListUserProfile>(_loadListUserProfile);
    on<PageChange>(_pageChange);
    on<FollowUser>(_toggleFollow1);
  }
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
        final response = ProfileResponse.fromJson(res.body);
        var url1 = '${ApiEndPoints.LOADPOST}/user/${response.user.id}';
        var params = {'page': '1', 'limit': '24'};

        ApiResponse res1 = await ApiUtil.get(url1, params: params);
        if (res1.statusCode == 200) {
          final posts =
              (res1.body['data']['posts'] as List)
                  .map((e) => PostChild.fromJson(e))
                  .toList();
          emit(
            ProfileSuccess(
              reels: [],
              posts: posts,
              user: response.user,
              stats: response.stats,
              hasFollow: response.isFollowing,
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      emit(ProfileFailure(erroMessage: e.toString()));
    }
    return;
  }

  Future<void> _toggleFollow1(
    FollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state as ProfileSuccess;
    print('IsFollow: ${event.isFollowing}');
    if (event.isFollowing) {
      final url = '${ApiEndPoints.PROFILE}/contacts/${event.id}';
      ApiResponse res = await ApiUtil.delete(url);
      if (res.statusCode == 200) {
        emit(currentState.copyWith(hasFollow: false));
      } else {
        emit(currentState.copyWith(hasFollow: true));
      }
    } else {
      final url = '${ApiEndPoints.PROFILE}/contacts/${event.id}';
      ApiResponse res = await ApiUtil.post(url: url);
      if (res.statusCode == 201) {
        emit(currentState.copyWith(hasFollow: true));
      } else {
        emit(currentState.copyWith(hasFollow: false));
      }
    }
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
        final isFollowing = res.body['data']['is_following'];
        var url1 = '${ApiEndPoints.LOADPOST}/user/${user.id}';
        var params = {'page': '1', 'limit': '24'};
        ApiResponse res1 = await ApiUtil.get(url1, params: params);

        if (res1.statusCode == 200) {
          final posts =
              (res1.body['data']['posts'] as List)
                  .map((e) => PostChild.fromJson(e))
                  .toList();
          emit(
            ProfileSuccess(
              user: user,
              conversationId: converationId,
              posts: posts,
              hasFollow: isFollowing,
            ),
          );
        }
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

  Future<void> _pageChange(PageChange event, Emitter<ProfileState> emit) async {
    final currentState = state as ProfileSuccess;

    try {
      // Lắng nghe sự kiện khi tab thay đổi
      event.tabController.addListener(() {
        if (event.tabController.indexIsChanging)
          return; // bỏ qua khi đang animation
        final index = event.tabController.index;
        add(LoadListUserProfile(event.user!, index));
      });
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }

  Future<void> _loadListUserProfile(
    LoadListUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      var following, suggestUsers;
      var url = '${ApiEndPoints.USERS}/friends';
      var params = {'page': '1', 'limit': '20'};
      ApiResponse res = await ApiUtil.get(url, params: params);
      var url1 = '${ApiEndPoints.USERS}/followers';
      var params1 = {'page': '1', 'limit': '20'};
      ApiResponse res2 = await ApiUtil.get(url1, params: params1);
      if (res2.statusCode == 200) {
        following =
            (res.body as List).map((e) => UserModel.fromJson(e)).toList();
      }
      if (res.statusCode == 200) {
        suggestUsers =
            (res.body as List).map((e) => UserModel.fromJson(e)).toList();
      }
      emit(
        ProfileSuccess(
          usersContatct: suggestUsers,
          userFollowing: following,
          user: event.user,
        ),
      );
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }

  Future<void> _editProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      var url = ApiEndPoints.PROFILE1;
      final params = {
        "username": event.user.username,
        "email": event.user.email,
        "avatar_url": event.user.avatar,
        "status": event.user.status,
        "full_name": event.user.fullname,
        "gender": event.user.gender,
        "is_private": event.user.isPrivate,
        "bio": event.user.bio,
      };
      print(params);
      ApiResponse res = await ApiUtil.put(url, params);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']);
        await AppStorage.clearUser();
        await AppStorage.saveUser(user);
        emit(ProfileSuccess(user: user));
      }
    } catch (e) {
      print(e.toString());
      emit(ProfileFailure());
    }
    return;
  }
}
