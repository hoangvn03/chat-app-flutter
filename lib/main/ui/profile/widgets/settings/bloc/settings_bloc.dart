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
      final response = await ApiUtil.post(url: url, data: data);
      if (response['message'] == 'Logout successful') {
        final res = response['message'];
        await AppStorage.clearUser();
      }
    } catch (e) {
      emit(SettingFailure());
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
          id: "1",
          user: UserModel( id:999,

            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=1",
          caption: "Cuối tuần chill 😎",
          likes: 120,
          typePost: "reels",
          timeAgo: "2 giờ trước",
        ),
        PostModel(
          id: "2",
          user: UserModel( id:999,

            username: 'linh_nguyen',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=2",
          caption: "Cà phê sáng ☕",
          likes: 89,
          timeAgo: "5 giờ trước",
        ),
        PostModel(
          id: "3",
          user: UserModel( id:999,
username: 'lisa', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=3",
          caption: "Coding all day 💻🔥",
          likes: 300,
          timeAgo: "1 ngày trước",
        ),
        PostModel(
          id: "4",
          user: UserModel( id:999,

            username: 'thanh_nguyen',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "5",
          user: UserModel( id:999,

            username: 'tuan_anh',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=5",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "6",
          typePost: "reels",
          user: UserModel( id:999,

            username: 'minh_hieu',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=6",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "7",
          typePost: "reels",
          user: UserModel( id:999,
username: 'rosé', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=7",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "8",
          typePost: "video",
          user: UserModel( id:999,

            username: 'david',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=8",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "9",
          user: UserModel( id:999,

            username: 'yasuo',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=9",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "10",
          user: UserModel( id:999,

            username: 'hasagi',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=10",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "11",
          user: UserModel( id:999,
username: 'anna', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=11",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "12",
          user: UserModel( id:999,

            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
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
