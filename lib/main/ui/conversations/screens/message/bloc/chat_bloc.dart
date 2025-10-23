import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../networks/api_util.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatLoading()) {
    on<LoadMessage>(_loadListMessage);
    on<ReceiveMessage>(_receiveMessage);
    on<SendMessage>(_sendMessage);
  }
  SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];
  Future<void> _loadListMessage(
    LoadMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      var url =
          '${ApiEndPoints.GETMESSAGE}/${event.conversation.conversationId}';
      final userOnline = getOnlineUserIds(event.conversation.participants);
      ApiResponse res = await ApiUtil.get(url);
      if (res.statusCode == 200) {
        final data = MessageData.fromJson(res.body['data']);
        _messages.clear();
        _messages.addAll(data.messages);
        emit(
          ChatSuccess(messages: List.from(_messages), userOnline: userOnline),
        );
        _socketService.socket.emit(
          'join_conversation',
          event.conversation.conversationId,
        );
        _socketService.socket.on('new_message', (data) {
          print("B1 Gui :$data");
          add(ReceiveMessage(data));
        });
      } else {
        emit(ChatFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
    return;
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state is! ChatSuccess) return;
    try {
      var param = {
        'conversation_id': event.conversationId,
        'content': event.message,
      };
      _socketService.socket.emit('send_message', param);
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _receiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;
    try {
      print('B2 Receive Message');
      print(event.message);
      final msg = event.message['message'] ?? event.message;

      final message = MessageEntity(
        messageId:
            msg['message_id'] is String
                ? int.tryParse(msg['message_id']) ?? 0
                : (msg['message_id'] ?? 0),
        conversationId:
            msg['conversation_id'] is String
                ? int.tryParse(msg['conversation_id']) ?? 0
                : (msg['conversation_id'] ?? 0),
        senderId:
            msg['sender_id'] is String
                ? int.tryParse(msg['sender_id']) ?? 0
                : (msg['sender_id'] ?? 0),
        content: msg['content'] ?? '',
        createdAt: DateTime.tryParse(msg['created_at'] ?? '') ?? DateTime.now(),
        isRead: msg['is_read'] ?? false,
        sender:
            msg['sender'] != null ? UserModel.fromJson(msg['sender']) : null,
        statuses:
            msg['statuses'] != null
                ? (msg['statuses'] as List)
                    .map((e) => Status.fromJson(e))
                    .toList()
                : [],
      );
      _messages.add(message);
      emit(currentState.copyWith(messages: List.from(_messages)));
      // emit(ChatSuccess(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  List<String> getOnlineUserIds(List<UserModel> participants) {
    final name = <String>{};
      for (final user in participants) {
        if (user.status == 'online' && user.username != null) {
          name.add(user.username!);
        }
    }
    return name.toList();
  }

  @override
  Future<void> close() {
    // Ngắt lắng nghe event khi rời màn
    _socketService.socket.off('new_message');
    _socketService.socket.off('send_message');
    return super.close();
  }
}
