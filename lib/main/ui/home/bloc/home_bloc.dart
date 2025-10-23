import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    // on<LoadListUser>(_loadListUser);
    on<LoadRequest>(_loadRequest);
    // on<DeletetUser>(_deleteUser);
    // on<UpdateUser>(_updateUser);
  }
  UserModel user = UserModel( id:999,
);
  Future<void> _loadListUser(LoadRequest event, Emitter<HomeState> emit) async {
    try {
      var url = ApiEndPoints.USERS;
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

  Future<void> _loadRequest(LoadRequest event, Emitter<HomeState> emit) async {
    try {
            final user = await AppStorage.getUser();

      final List<PostModel> posts = [
        PostModel(
          id: "1",
          user: UserModel( id:999,
username: 'david', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=1",
          caption: "Cuối tuần chill 😎",
          likes: 120,
          timeAgo: "2 giờ trước",
        ),
        PostModel(
          id: "2",
          user: UserModel( id:999,

            username: 'hieu_thu_2',
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
username: 'rose', avatar: AppImages.imgAvatarDefault),
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
      emit(HomeSuccess(reels: reels, posts: posts,user: user));
    } catch (e) {
      emit(HomeFailure());
    }
    return;
  }

  // Future<void> _loadListPost(
  //   LoadListPost event,
  //   Emitter<HomeState> emit,
  // ) async {
  //   try {
  //     final List<PostModel> posts = [
  //       PostModel(
  //         id: "1",
  //         userusername: "ngoc_hoang",
  //         userAvatar: "https://randomuser.me/api/portraits/men/1.jpg",
  //         postImage: "https://picsum.photos/400/400?random=1",
  //         caption: "Cuối tuần chill 😎",
  //         likes: 120,
  //         timeAgo: "2 giờ trước",
  //       ),
  //       PostModel(
  //         id: "2",
  //         userusername: "linh_nguyen",
  //         userAvatar: "https://randomuser.me/api/portraits/women/2.jpg",
  //         postImage: "https://picsum.photos/400/400?random=2",
  //         caption: "Cà phê sáng ☕",
  //         likes: 89,
  //         timeAgo: "5 giờ trước",
  //       ),
  //       PostModel(
  //         id: "3",
  //         userusername: "david",
  //         userAvatar: "https://randomuser.me/api/portraits/men/3.jpg",
  //         postImage: "https://picsum.photos/400/400?random=3",
  //         caption: "Coding all day 💻🔥",
  //         likes: 300,
  //         timeAgo: "1 ngày trước",
  //       ),
  //       PostModel(
  //         id: "4",
  //         userusername: "anna",
  //         userAvatar: "https://randomuser.me/api/portraits/women/4.jpg",
  //         postImage: "https://picsum.photos/400/400?random=4",
  //         caption: "Du lịch biển 🌊",
  //         likes: 240,
  //         timeAgo: "2 ngày trước",
  //       ),
  //     ];

  //     emit(HomeSuccess(posts: posts));
  //   } catch (e) {
  //     emit(HomeFailure());
  //   }
  //   return;
  // }

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
