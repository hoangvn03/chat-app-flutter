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
      final List<PostModel> posts = [
        PostModel(
          postId: 1,
          userId: 1,
          caption:
              "Buổi sáng tuyệt vời tại Hà Nội! Thật sự thư giãn. #travel #hanoi",
          location: "Bạch Thanh Trà",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-08T06:29:07.000Z"),
          updatedAt: DateTime.parse("2025-11-08T06:29:07.000Z"),
          author: UserModel(
            id: 1,
            username: "alice",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Alice",
          ),
        ),
        PostModel(
          postId: 2,
          userId: 2,
          caption: "Cà phê sáng ở Đà Lạt thật chill ☕🌿 #coffee #dalat",
          location: "Tiệm cà phê Mộc",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-07T08:45:20.000Z"),
          updatedAt: DateTime.parse("2025-11-07T08:45:20.000Z"),
          author: UserModel(
            id: 2,
            username: "bob",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Bob",
          ),
        ),
        PostModel(
          postId: 3,
          userId: 3,
          caption: "Chiều hoàng hôn bên sông thật đẹp 🌅 #sunset #relax",
          location: "Bến Bạch Đằng",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-06T17:30:00.000Z"),
          updatedAt: DateTime.parse("2025-11-06T17:30:00.000Z"),
          author: UserModel(
            id: 3,
            username: "carol",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Carol",
          ),
        ),
        PostModel(
          postId: 4,
          userId: 4,
          caption: "Làm việc chăm chỉ hôm nay để mai thành công 💪 #workhard",
          location: "Hồ Chí Minh",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-05T09:00:00.000Z"),
          updatedAt: DateTime.parse("2025-11-05T09:00:00.000Z"),
          author: UserModel(
            id: 4,
            username: "david",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=David",
          ),
        ),
        PostModel(
          postId: 5,
          userId: 5,
          caption: "Một ngày nắng đẹp để đi dạo 🌞 #weekend #happy",
          location: "Cầu Thủ Thiêm 2",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-04T15:15:00.000Z"),
          updatedAt: DateTime.parse("2025-11-04T15:15:00.000Z"),
          author: UserModel(
            id: 5,
            username: "emma",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Emma",
          ),
        ),
      ];

        final reels = [
          ReelModel(user: UserModel(id: 999, username: "Hoang")),
          ReelModel(user: UserModel(id: 999, username: "Tuan Anh")),
        ];
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
