import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/Profile/bloc/Profile_event.dart';
import 'package:chat_app/main/ui/Profile/bloc/Profile_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadRequest>(_loadRequest);

  }
  UserModel user = UserModel();
  Future<void> _loadListUser(
    LoadRequest event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      var url = ApiEndPoints.USERINFO;
      final response = await ApiUtil.post(url: url);
      if (response['code'] == 0) {
        user = UserModel.fromJson(response['user']);
        emit(ProfileSuccess(user: user));
      } else {
        emit(ProfileFailure());
      }
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }

  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<ProfileState> emit,
  ) async {
    try {
         final List<PostModel> posts = [
        PostModel(
          id: "1",
          username: "ngoc_hoang",
          userAvatar: "https://randomuser.me/api/portraits/men/1.jpg",
          postImage: "https://picsum.photos/400/400?random=1",
          caption: "Cuối tuần chill 😎",
          likes: 120,
          timeAgo: "2 giờ trước",
        ),
        PostModel(
          id: "2",
          username: "linh_nguyen",
          userAvatar: "https://randomuser.me/api/portraits/women/2.jpg",
          postImage: "https://picsum.photos/400/400?random=2",
          caption: "Cà phê sáng ☕",
          likes: 89,
          timeAgo: "5 giờ trước",
        ),
        PostModel(
          id: "3",
          username: "david",
          userAvatar: "https://randomuser.me/api/portraits/men/3.jpg",
          postImage: "https://picsum.photos/400/400?random=3",
          caption: "Coding all day 💻🔥",
          likes: 300,
          timeAgo: "1 ngày trước",
        ),
        PostModel(
          id: "4",
          username: "anna",
          userAvatar: "https://randomuser.me/api/portraits/women/4.jpg",
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
      ];

      final reels = [
        ReelModel(user: UserModel(name: "Hoang")),
        ReelModel(user: UserModel(name: "Tuan Anh")),
      ];
      emit(ProfileSuccess(reels: reels,posts: posts));
    } catch (e) {
      emit(ProfileFailure());
    }
    return;
  }
}
