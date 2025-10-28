import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../networks/api_util.dart';

class CreateChatBloc extends Bloc<CreateChatEvent, CreateChatState> {
  CreateChatBloc() : super(CreateChatLoading()) {
    on<CreateNewChat>(_createNewChat);
    on<LoadListUser>(_loadUser);
    on<AddUserToGroup>(_addUserToGroup);
    on<RemoveUserToGroup>(_removeUserToGroup);
    on<ClearCreateChat>(_clearData);
  }

  final List<UserModel> memberGroup = [];
  Future<void> _createNewChat(
    CreateNewChat event,
    Emitter<CreateChatState> emit,
  ) async {
    try {
      var url = ApiEndPoints.CONVERATIONS;
      print(url);
      var body = {
        "is_group": event.isGroup,
        "conversation_name": event.converationName,
        "participant_ids": event.participantIds,
      };
      ApiResponse res = await ApiUtil.post(url: url, data: body);
      if (res.statusCode == 201) {
        memberGroup.clear();
        final data = Conversation.fromJson(res.body['data']['conversation']);
        if (state is CreateChatSuccess) {
          final current = state as CreateChatSuccess;
          emit(current.copyWith(conversation: data, isCreateSuccess: true));
        } else if (res.statusCode == 409) {
          CreateChatFailure(
            erorCode: res.statusCode,
            '${res.statusCode} ${res.body['error']['message']}',
          );
        } else {
          CreateChatFailure(
            '${res.statusCode} ${res.body['error']['message']}',
          );
        }
      } else {
        emit(
          CreateChatFailure(
            '${res.statusCode} ${res.body['error']['message']}',
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      emit(CreateChatFailure(e.toString()));
    }
    return;
  }

  Future<void> _loadUser(
    LoadListUser event,
    Emitter<CreateChatState> emit,
  ) async {
    if (state is CreateChatSuccess) {
      emit((state as CreateChatSuccess).copyWith(isLoading: true));
    }

    try {
      var url = ApiEndPoints.USERS;
      var params = {'page': '1', 'limit': '10', 'search': event.input};
      ApiResponse res = await ApiUtil.get(url, params: params);

      if (res.statusCode == 200) {
        final data = UserResponse.fromJson(res.body['data']);

        if (state is CreateChatSuccess) {
          final current = state as CreateChatSuccess;
          emit(current.copyWith(users: data.users, isLoading: false));
        } else {
          emit(CreateChatSuccess(users: data.users, isLoading: false));
        }
      } else {
        emit(CreateChatFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(CreateChatFailure(e.toString()));
    }
  }

  Future<void> _addUserToGroup(
    AddUserToGroup event,
    Emitter<CreateChatState> emit,
  ) async {
    memberGroup.add(event.user);
    if (state is CreateChatSuccess) {
      final current = state as CreateChatSuccess;
      emit(current.copyWith(members: memberGroup));
    }
  }

  Future<void> _removeUserToGroup(
    RemoveUserToGroup event,
    Emitter<CreateChatState> emit,
  ) async {
    memberGroup.remove(event.user);
    if (state is CreateChatSuccess) {
      final current = state as CreateChatSuccess;
      emit(current.copyWith(members: memberGroup));
    }
  }

  Future<void> _clearData(
    ClearCreateChat event,
    Emitter<CreateChatState> emit,
  ) async {
    memberGroup.clear();
    emit(CreateChatLoading()); // hoặc CreateChatSuccess(members: [], users: [])
  }
}
