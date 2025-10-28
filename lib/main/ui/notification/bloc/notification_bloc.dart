import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/notification/bloc/notification_event.dart';
import 'package:chat_app/main/ui/notification/bloc/notification_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import '../../../networks/api_util.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationLoading()) {
    on<LoadNotification>(_getNotification);
    on<LoadUnreadNotification>(_getUnReadNotification);
    on<LoadSeenUnSeenNitification>(_getSeenOrUnSeenNotification);
    on<CreateNotification>(_createNotification);
  }

  Future<void> _getNotification(
    LoadNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      var url = ApiEndPoints.NOTIFICATION;
      final params = {'page': '1', 'limit': '20'};
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']['user']);
        print(user.bio);

        // emit(NotificationSuccess(reels: reels, posts: posts, user: user));
      }
    } catch (e) {
      emit(NotificationFailure());
    }
    return;
  }

  Future<void> _getUnReadNotification(
    LoadUnreadNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      var url = ApiEndPoints.NOTIFICATION;
      final params = {'is_seen': false};
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']['user']);
        print(user.bio);

        // emit(NotificationSuccess(reels: reels, posts: posts, user: user));
      }
    } catch (e) {
      emit(NotificationFailure());
    }
    return;
  }

  Future<void> _getSeenOrUnSeenNotification(
    LoadSeenUnSeenNitification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      var url = ApiEndPoints.NOTIFICATION;
      final params = {'is_seen': false}; //true
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']['user']);
        print(user.bio);

        // emit(NotificationSuccess(reels: reels, posts: posts, user: user));
      }
    } catch (e) {
      emit(NotificationFailure());
    }
    return;
  }

  //type: new_message , friend_request , group_invite
  Future<void> _createNotification(
    CreateNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      var url = ApiEndPoints.NOTIFICATION;
      final params = {
        "user_id": 2,
        "type": "group_invite",
        "content": "You have been invited to join 'Project Team' group",
      };
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final user = UserModel.fromJson(res.body['data']['user']);
        print(user.bio);

        // emit(NotificationSuccess(reels: reels, posts: posts, user: user));
      }
    } catch (e) {
      emit(NotificationFailure());
    }
    return;
  }
}
