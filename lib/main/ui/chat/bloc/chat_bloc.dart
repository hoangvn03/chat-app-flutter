import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
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
    on<LoadRequest>(_loadListConversation);
    on<LoadDetailConveration>(_loadDetailConversation);
    on<SendMessage>(_sendMessage);
  }
  Future<void> _loadListConversation(
    LoadRequest event,
    Emitter<ChatState> emit,
  ) async {
    try {
      var url = ApiEndPoints.CONVERATIONS;
      var params = {'page': '1', 'limit': '10'};
      print(url);
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final data = ConversationResponse.fromJson(res.body['data']);
        emit(ChatSuccess(data: data));
      } else {
        emit(ChatFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
    return;
  }

  Future<void> _loadDetailConversation(
    LoadDetailConveration event,
    Emitter<ChatState> emit,
  ) async {
    try {
      var url = '${ApiEndPoints.GETMESSAGE}/${event.id}';
      print(url);
      ApiResponse res = await ApiUtil.get(url);
      if (res.statusCode == 200) {
        final data = MessageData.fromJson(res.body['data']);
        emit(ChatSuccess(message: data));
      } else {
        emit(ChatFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
    return;
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state is! ChatSuccess) return; // chỉ xử lý khi đã load xong hội thoại
    final currentState = state as ChatSuccess;

    try {
      var url = ApiEndPoints.SENDMESSAGE;
      var param = {
        'conversation_id': event.conversationId,
        'content': event.message,
      };

      ApiResponse res = await ApiUtil.post(url: url, data: param);
      if (res.statusCode == 201) {
        final newMessage = MessageModel.fromJson(res.body['data']['message']);

        final updatedMessages = List<MessageModel>.from(
          currentState.message?.messages ?? [],
        )..add(newMessage); // ✅ thêm tin nhắn mới vào cuối danh sách

        // ✅ tạo lại đối tượng MessageData mới
        final updatedData = MessageData(messages: updatedMessages);

        // emit lại state mới có cả danh sách tin nhắn mới
        emit(ChatSuccess(message: updatedData));
      } else {
        emit(ChatFailure('${res.statusCode} Fail to send message'));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
