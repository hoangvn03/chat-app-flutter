import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
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
    on<LoadRequest>(_loadRequest);
    on<ClearStrogeUser>(_clearUser);
  }
  UserModel user = UserModel();
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
    LoadRequest event,
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
            id: "1",
            user: UserModel(
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
            user: UserModel(
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
            user: UserModel(
              username: 'lisa',
              avatar: AppImages.imgAvatarDefault,
            ),
            postImage: "https://picsum.photos/400/400?random=3",
            caption: "Coding all day 💻🔥",
            likes: 300,
            timeAgo: "1 ngày trước",
          ),
          PostModel(
            id: "4",
            user: UserModel(
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
            user: UserModel(
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
            user: UserModel(
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
            user: UserModel(
              username: 'rosé',
              avatar: AppImages.imgAvatarDefault,
            ),
            postImage: "https://picsum.photos/400/400?random=7",
            caption: "Du lịch biển 🌊",
            likes: 240,
            timeAgo: "2 ngày trước",
          ),
          PostModel(
            id: "8",
            typePost: "video",
            user: UserModel(
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
            user: UserModel(
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
            user: UserModel(
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
            user: UserModel(
              username: 'anna',
              avatar: AppImages.imgAvatarDefault,
            ),
            postImage: "https://picsum.photos/400/400?random=11",
            caption: "Du lịch biển 🌊",
            likes: 240,
            timeAgo: "2 ngày trước",
          ),
          PostModel(
            id: "12",
            user: UserModel(
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
          ReelModel(user: UserModel(username: "Hoang")),
          ReelModel(user: UserModel(username: "Tuan Anh")),
        ];
        emit(ProfileSuccess(reels: reels, posts: posts, user: user));
      }
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }
}
