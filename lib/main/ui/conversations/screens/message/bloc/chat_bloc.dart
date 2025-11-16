import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_state.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';

import '../../../../../networks/api_util.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketService socketService;
  ChatBloc(this.socketService) : super(ChatLoading()) {
    on<LoadMessage>(_loadListMessage);
    on<ReceiveMessage>(_receiveMessage);
    on<SendMessage>(_sendMessage);
    on<UserTypingOrStopTypingEvent>(_onUserTypingOrStopTyping);
    on<UpdateTypingEvent>(_updateStateTyping);
    on<UpdateOnlineUsers>(_updateOnlineUser);
    on<UpdateStatusUsers>(_updateStatusUser);
    // on<UploadFileMessage>(_uploadFileMessage);
    on<UpdateStatusMessage>(_updateStatusMessage);
  }
  // final SocketService socketService = SocketService();
  final List<MessageEntity> _messages = [];
  final List<UserModel> _userTyping = [];
  final List<UserModel> _userOnline = [];
  final List<Attachment> _listFile = [];
  final List<AssetEntity> _listFilesSend = [];
  final List<File> _listFilesPath = [];
  Future<void> _loadListMessage(
    LoadMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      var url =
          '${ApiEndPoints.GETMESSAGE}/${event.conversation.conversationId}';
      ApiResponse res = await ApiUtil.get(url);
      if (res.statusCode == 200) {
        final data = MessageData.fromJson(res.body['data']);
        _messages.clear();
        _messages.addAll(data.messages);
        emit(ChatSuccess(messages: List.from(_messages)));
        socketService.joinConversation(event.conversation.conversationId);
        socketService.getUsersOnine(event.conversation.conversationId);
        socketService.socket.on('user_typing', (data) {
          final userid = data['user_id'];
          final username = data['username'];
          final convId = data['conversation_id'];
          final user = UserModel(id: userid, username: username);
          print('Step Typing 2 :$username + $convId');
          add(UpdateTypingEvent(user, false));
        });

        socketService.socket.on('user_stopped_typing', (data) {
          final username = data['username'];
          final userid = data['user_id'];
          final convId = data['conversation_id'];
          final user = UserModel(id: userid, username: username);
          print('Step Typing 3 :$username + $convId');
          add(UpdateTypingEvent(user, true));
        });
        socketService.socket.on('new_message', (data) {
          print("B1 Gui :$data");
          add(ReceiveMessage(data));
        });
        socketService.socket.on('message_status_updated', (data) {
          add(
            UpdateStatusMessage(
              messageId: data['message_id'],
              receiverId: data['reader_id'],
            ),
          );
        });
        socketService.socket.on('online_users', (data) {
          final onlineList = data['online_users'] as List<dynamic>? ?? [];
          final users = onlineList.map((u) => UserModel.fromJson(u)).toList();
          add(UpdateOnlineUsers(onlineUsers: users));
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
      var params = {
        'conversation_id': event.conversationId,
        'content': event.message,
      };
      if (event.mediaFiles != null) {
        _listFilesSend.addAll(event.mediaFiles!);
      } else if (event.files != null) {
        _listFilesPath.addAll(event.files!);
      }
      socketService.sendMessage(params);
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
    emit(
      ChatSuccess(
        messages: List.from(currentState.messages),
        statusMessage: null, 
      ),
    );
    try {
      final msg = event.message['message'] ?? event.message;
      List<Attachment> attachments = [];

      if (_listFilesSend.isNotEmpty || _listFilesPath.isNotEmpty) {
        final fileList =
            _listFilesSend.isNotEmpty ? _listFilesSend : _listFilesPath;
        final uploaded = await _uploadFileMessage(
          UploadFileMessage(
            file: fileList,
            conversationId: int.tryParse("${msg['conversation_id']}") ?? 0,
            messageId: int.tryParse("${msg['message_id']}") ?? 0,
          ),
        );
        print("Upload file result: ${uploaded.errorMessage}");
        if (uploaded.errorMessage != null) {
          _listFilesSend.clear();
          _listFilesPath.clear();
          _listFile.clear();
          emit(
            ChatSuccess(
              messages: List.from(currentState.messages),
              statusMessage: uploaded.errorMessage,
            ),
          );
          return;
        }
        attachments = uploaded.attachments ?? [];
      }

      final message = MessageEntity(
        messageId: int.tryParse("${msg['message_id']}") ?? 0,
        conversationId: int.tryParse("${msg['conversation_id']}") ?? 0,
        senderId: int.tryParse("${msg['sender_id']}") ?? 0,
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
        attachments: attachments,
      );

      final newMessages = List<MessageEntity>.from(currentState.messages)
        ..add(message);
      _listFilesSend.clear();
      _listFilesPath.clear();
      _listFile.clear();
      emit(ChatSuccess(messages: newMessages, statusMessage: null));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _updateStateTyping(
    UpdateTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;
    try {
      final user = event.user;
      if (!event.isStop) {
        // chỉ thêm nếu chưa có id này
        if (!_userTyping.any((u) => u.id == user.id)) {
          print('Step Typing 3 :${user.id}');

          _userTyping.add(user);
          emit(currentState.copyWith(typingUsers: List.from(_userTyping)));
        }
      } else {
        // xóa theo id
        _userTyping.removeWhere((u) => u.id == user.id);
        emit(currentState.copyWith(typingUsers: List.from(_userTyping)));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onUserTypingOrStopTyping(
    UserTypingOrStopTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    final current = state;
    if (!event.isStop) {
      print('Step Typing 1 : ${event.conversationId}');
      if (current is ChatSuccess) {
        socketService.startTyping(event.conversationId);
      }
    } else {
      print('Step Typing 4 : ${event.conversationId}');
      if (current is ChatSuccess) {
        socketService.stopTyping(event.conversationId);
      }
    }
  }

  Future<void> _updateOnlineUser(
    UpdateOnlineUsers event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;

    try {
      _userOnline.clear();
      _userOnline.addAll(event.onlineUsers);
      emit(currentState.copyWith(onlineUsers: _userOnline));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _updateStatusUser(
    UpdateStatusUsers event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;
    try {
      if (event.isInit) {
        socketService.updateUserStatus(StatusUser.online.name);
      } else {
        emit(currentState.copyWith(onlineUsers: _userOnline));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _updateStatusMessage(
    UpdateStatusMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;
    try {
      socketService.markMessageAsRead(event.messageId, event.receiverId);
      // Cập nhật trong local state
      final updatedMessages =
          currentState.messages.map((msg) {
            if (msg.messageId == event.messageId) {
              return msg.copyWith(isRead: true);
            }
            return msg;
          }).toList();

      emit(currentState.copyWith(messages: updatedMessages));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<UploadResult> _uploadFileMessage(UploadFileMessage event) async {
    try {
      var files;

      if (event.file is List<AssetEntity>) {
        files = await convertAssetEntitiesToFiles(
          event.file as List<AssetEntity>,
        );
      } else if (event.file is List<File>) {
        files = event.file;
      }

      final url = '${ApiEndPoints.SENDFILE}/${event.messageId}';
      ApiResponse res = await ApiUtil.postFiles(url: url, files: files);

      if (res.statusCode == 201) {
        final data =
            (res.body['data'] as List)
                .map((e) => Attachment.fromJson(e))
                .toList();
        return UploadResult(attachments: data);
      } else {
        return UploadResult(
          errorMessage: res.body['error']['message'] ?? 'Upload file failed',
        );
      }
    } catch (e) {
      return UploadResult(errorMessage: e.toString());
    }
  }

  @override
  Future<void> close() {
    socketService.socket.off('new_message');
    socketService.socket.off('user_typing');
    socketService.socket.off('user_stopped_typing');
    socketService.socket.off('message_status_updated');
    socketService.socket.off('online_users');
    return super.close();
  }
}

class UploadResult {
  final List<Attachment>? attachments;
  final String? errorMessage;

  UploadResult({this.attachments, this.errorMessage});
}
