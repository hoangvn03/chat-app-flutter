import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_event.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatLoading()) {
    // on<LoadListUser>(_loadListUser);
    on<LoadRequest>(_loadRequest);
    // on<DeletetUser>(_deleteUser);
    // on<UpdateUser>(_updateUser);
  }
  UserModel user = UserModel();
  Future<void> _loadListUser(LoadRequest event, Emitter<ChatState> emit) async {
    try {
      var url = ApiEndPoints.USERINFO;
      final response = await ApiUtil.post(url: url);
      if (response['code'] == 0) {
        user = UserModel.fromJson(response['user']);
        emit(ChatSuccess(user: user));
      } else {
        emit(ChatFailure());
      }
    } catch (e) {
      emit(ChatFailure());
    }
    return;
  }

  Future<void> _loadRequest(LoadRequest event, Emitter<ChatState> emit) async {
    try {
      final List<PostModel> posts = [
        PostModel(
          id: "1",
          user: UserModel(
            name: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=1",
          caption: "Cuối tuần chill 😎",
          likes: 120,
          timeAgo: "2 giờ trước",
        ),
        PostModel(
          id: "2",
                   user: UserModel(
            name: 'hieu_pham',
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
            name: 'hieu_pham',
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
            name: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
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
      emit(ChatSuccess(reels: reels, posts: posts));
    } catch (e) {
      emit(ChatFailure());
    }
    return;
  }

  // Future<void> _loadListPost(
  //   LoadListPost event,
  //   Emitter<ChatState> emit,
  // ) async {
  //   try {
  //     final List<PostModel> posts = [
  //       PostModel(
  //         id: "1",
  //         username: "ngoc_hoang",
  //         userAvatar: "https://randomuser.me/api/portraits/men/1.jpg",
  //         postImage: "https://picsum.photos/400/400?random=1",
  //         caption: "Cuối tuần chill 😎",
  //         likes: 120,
  //         timeAgo: "2 giờ trước",
  //       ),
  //       PostModel(
  //         id: "2",
  //         username: "linh_nguyen",
  //         userAvatar: "https://randomuser.me/api/portraits/women/2.jpg",
  //         postImage: "https://picsum.photos/400/400?random=2",
  //         caption: "Cà phê sáng ☕",
  //         likes: 89,
  //         timeAgo: "5 giờ trước",
  //       ),
  //       PostModel(
  //         id: "3",
  //         username: "david",
  //         userAvatar: "https://randomuser.me/api/portraits/men/3.jpg",
  //         postImage: "https://picsum.photos/400/400?random=3",
  //         caption: "Coding all day 💻🔥",
  //         likes: 300,
  //         timeAgo: "1 ngày trước",
  //       ),
  //       PostModel(
  //         id: "4",
  //         username: "anna",
  //         userAvatar: "https://randomuser.me/api/portraits/women/4.jpg",
  //         postImage: "https://picsum.photos/400/400?random=4",
  //         caption: "Du lịch biển 🌊",
  //         likes: 240,
  //         timeAgo: "2 ngày trước",
  //       ),
  //     ];

  //     emit(ChatSuccess(posts: posts));
  //   } catch (e) {
  //     emit(ChatFailure());
  //   }
  //   return;
  // }

  // Future<void> _deleteUser(DeletetUser event, Emitter<ChatState> emit) async {
  //   try {
  //     String url =
  //         '${ApiEndPoints.DELETEUSER}/${event.userId}'; // Assuming userId is passed in the event
  //     final response = await ApiUtil.delete(url);
  //     if (response['status_code'] == 200) {
  //       final List<UserModel> users =
  //           (response['data'] as List)
  //               .map((user) => UserModel.fromJson(user))
  //               .toList();
  //       emit(ChatSuccess(users));
  //     } else {
  //       emit(ChatFailure());
  //     }
  //   } catch (e) {
  //     emit(ChatFailure());
  //   }
  //   return;
  // }

  // Future<void> _updateUser(UpdateUser event, Emitter<ChatState> emit) async {
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
  //       emit(ChatSuccess(listUser));
  //     } else {
  //       emit(ChatFailure());
  //     }
  //   } catch (e) {
  //     emit(ChatFailure());
  //   }
  //   return;
  // }
}
