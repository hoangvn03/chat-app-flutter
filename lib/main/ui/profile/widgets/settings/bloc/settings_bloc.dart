import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/profile/widgets/settings/bloc/settings_event.dart';
import 'package:chat_app/main/ui/profile/widgets/settings/bloc/settings_state.dart';

import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingLoading()) {
    on<LoadRequest>(_loadRequest);
    on<ClearStrogeUser>(_clearUser);
  }
  UserModel user = UserModel( id:999,
);
  bool isCurrientUser = true;

  Future<void> _clearUser(
    ClearStrogeUser event,
    Emitter<SettingState> emit,
  ) async {
    try {
      emit(SettingLoading());
      final token = await AppStorage.getToken();
      var url = ApiEndPoints.SIGNIN;
      var data = {'token': token};
      ApiResponse res = await ApiUtil.post(url: url, data: data);
      if (res.statusCode == 200) {
      }else{
        emit(
          SettingFailure(erroMessage: 
            'Error ${res.statusCode}: ${res.body?['message'] ?? 'Unknown'}',
          ),
        );
      }
    } catch (e) {
      emit(SettingFailure(erroMessage: e.toString()));
    }
  }

  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<SettingState> emit,
  ) async {
    try {
      final user = UserModel( id:999,

        username: 'ngoc_hoang',
        avatar: AppImages.imgAvatarDefault,
      );
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
        ReelModel(user: UserModel( id:999,
username: "Hoang")),
        ReelModel(user: UserModel( id:999,
username: "Tuan Anh")),
      ];
      emit(SettingSuccess(reels: reels, posts: posts, user: user));
    } catch (e) {
      emit(SettingFailure());
    }
    return;
  }
  Future<void> _loadRequest1(
    LoadRequest event,
    Emitter<SettingState> emit,
  ) async {
    try {
      emit(SettingLoading());
            final token = await AppStorage.getToken();
      var url = ApiEndPoints.SIGNOUT;
      var data = {'token': token};
      ApiResponse res = await ApiUtil.post(url: url, data: data);
      if (res.statusCode == 200) {
        emit(SettingSuccess(user: res.body['message']));
      } else {
        emit(
          SettingFailure(erroMessage: 
            'Error ${res.statusCode}: ${res.body?['message'] ?? 'Unknown'}',
          ),
        );
      }
      emit(SettingSuccess(user: user));
    } catch (e) {
      emit(SettingFailure());
    }
    return;
  }
}
