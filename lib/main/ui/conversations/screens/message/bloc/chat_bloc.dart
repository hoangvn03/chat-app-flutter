import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_state.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

// Helper class for Upload result
class UploadResult {
  final List<Attachment>? attachments;
  final String? errorMessage;

  UploadResult({this.attachments, this.errorMessage});
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketService socketService = SocketService();
  // Giữ lại các biến tạm thời này để xử lý logic gửi file đính kèm
  // Tuy nhiên, lý tưởng nhất là đưa logic này vào một UseCase riêng hoặc xử lý stateless
  final List<AssetEntity> _tempFilesSend = [];
  final List<File> _tempFilesPath = [];

  ChatBloc() : super(ChatLoading()) {
    on<LoadMessage>(_onLoadListMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<SendMessage>(_onSendMessage);
    on<UserTypingOrStopTypingEvent>(_onUserTypingOrStopTyping);
    on<UpdateTypingEvent>(_onUpdateStateTyping);
    on<UpdateOnlineUsers>(_onUpdateOnlineUser);
    on<UpdateStatusUsers>(_onUpdateStatusUser);
    on<UpdateStatusMessage>(_onUpdateStatusMessage);
    on<ClearAlertMessage>(_onClearAlertMessage);
  }
  void _onClearAlertMessage(ClearAlertMessage event, Emitter<ChatState> emit) {
    if (state is ChatSuccess) {
      final cur = state as ChatSuccess;
      emit(
        ChatSuccess(
          messages: cur.messages,
          typingUsers: cur.typingUsers,
          onlineUsers: cur.onlineUsers,
          statusUserContact: cur.statusUserContact,
          statusMessage: null, // Reset lỗi tại đây
        ),
      );
    }
  }

  Future<void> _onLoadListMessage(
    LoadMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await socketService.initSocket();
      final url =
          '${ApiEndPoints.GETMESSAGE}/${event.conversation.conversationId}';
      final res = await ApiUtil.get(url);

      if (res.statusCode == 200) {
        final data = MessageData.fromJson(res.body['data']);

        // Emit success state initial
        emit(
          ChatSuccess(
            messages: data.messages,
            onlineUsers: [],
            typingUsers: [],
          ),
        );

        _setupSocketListeners(event.conversation.conversationId);
      } else {
        emit(ChatFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  void _setupSocketListeners(int conversationId) {
    socketService.joinConversation(conversationId);
    socketService.getUsersOnine(conversationId);

    socketService.socket.on('user_typing', (data) {
      final user = UserModel(id: data['user_id'], username: data['username']);
      print("user typing: ${user.username}");
      add(UpdateTypingEvent(user, false));
    });

    socketService.socket.on('user_stopped_typing', (data) {
      final user = UserModel(id: data['user_id'], username: data['username']);
      add(UpdateTypingEvent(user, true));
    });

    socketService.socket.on('new_message', (data) {
      debugPrint("New Message Received: $data");
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
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    try {
      if (event.mediaFiles != null) {
        _tempFilesSend.addAll(event.mediaFiles!);
      } else if (event.files != null) {
        _tempFilesPath.addAll(event.files!);
      }

      final params = {
        'conversation_id': event.conversationId,
        'content': event.message,
      };
      socketService.sendMessage(params);
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;

    try {
      final msg = event.message['message'] ?? event.message;
      List<Attachment> attachments = [];

      // Logic upload file đính kèm nếu có
      if (_tempFilesSend.isNotEmpty || _tempFilesPath.isNotEmpty) {
        final conversationId = int.tryParse("${msg['conversation_id']}") ?? 0;
        final messageId = int.tryParse("${msg['message_id']}") ?? 0;

        final uploadResult = await _uploadFileMessage(
          conversationId: conversationId,
          messageId: messageId,
        );

        if (uploadResult.errorMessage != null) {
          _clearTempFiles();
          emit(currentState.copyWith(statusMessage: uploadResult.errorMessage));
          return;
        }
        attachments = uploadResult.attachments ?? [];
        _clearTempFiles();
      }

      // Parse MessageEntity
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

      // Add to list strictly ensuring immutability
      final newMessages = List<MessageEntity>.from(currentState.messages)
        ..add(message);
      emit(currentState.copyWith(messages: newMessages, statusMessage: null));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  void _clearTempFiles() {
    _tempFilesSend.clear();
    _tempFilesPath.clear();
  }

  Future<void> _onUpdateStateTyping(
    UpdateTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;

    final currentTyping = List<UserModel>.from(currentState.typingUsers ?? []);
    final user = event.user;

    if (!event.isStop) {
      if (!currentTyping.any((u) => u.id == user.id)) {
        currentTyping.add(user);
      }
    } else {
      currentTyping.removeWhere((u) => u.id == user.id);
    }
    emit(currentState.copyWith(typingUsers: currentTyping));
  }

  Future<void> _onUserTypingOrStopTyping(
    UserTypingOrStopTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;

    if (!event.isStop) {
      socketService.startTyping(event.conversationId);
    } else {
      socketService.stopTyping(event.conversationId);
    }
  }

  Future<void> _onUpdateOnlineUser(
    UpdateOnlineUsers event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;
    emit(currentState.copyWith(onlineUsers: event.onlineUsers));
  }

  Future<void> _onUpdateStatusUser(
    UpdateStatusUsers event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    if (event.isInit) {
      socketService.updateUserStatus(StatusUser.online.name);
    }
    // Logic update user status có vẻ chưa hoàn thiện ở code gốc,
    // nhưng giữ nguyên structure để mở rộng sau.
  }

  Future<void> _onUpdateStatusMessage(
    UpdateStatusMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatSuccess) return;
    final currentState = state as ChatSuccess;

    socketService.markMessageAsRead(event.messageId, event.receiverId);

    final updatedMessages =
        currentState.messages.map((msg) {
          if (msg.messageId == event.messageId) {
            return msg.copyWith(isRead: true);
          }
          return msg;
        }).toList();

    emit(currentState.copyWith(messages: updatedMessages));
  }

  Future<UploadResult> _uploadFileMessage({
    required int conversationId,
    required int messageId,
  }) async {
    try {
      List<File> filesToUpload = [];

      if (_tempFilesSend.isNotEmpty) {
        // Convert AssetEntity to File
        for (var asset in _tempFilesSend) {
          final file = await asset.file;
          if (file != null) filesToUpload.add(file);
        }
      } else if (_tempFilesPath.isNotEmpty) {
        filesToUpload = _tempFilesPath;
      }

      if (filesToUpload.isEmpty) {
        return UploadResult(attachments: []);
      }

      final url = '${ApiEndPoints.SENDFILE}/$messageId';
      final res = await ApiUtil.postFiles(url: url, files: filesToUpload);

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
  Future<void> close() async {
    socketService.socket.off('new_message');
    socketService.socket.off('user_typing');
    socketService.socket.off('user_stopped_typing');
    socketService.socket.off('message_status_updated');
    socketService.socket.off('online_users');
    // socketService.disconnect();
    await socketService.dispose();
    return super.close();
  }
}
