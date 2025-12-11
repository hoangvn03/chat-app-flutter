import 'dart:async';
import 'dart:developer';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  bool get isConnected => _socket.connected;

Future<void> initSocket() async {
    final token = await AppStorage.getToken();
    print('Socket Token: $token');

    Map<String, dynamic> options = IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setExtraHeaders({"Authorization": "Bearer $token"})
        .setAuth({'token': token})
        .build();
    options['forceNew'] = true; 
    _socket = IO.io(
      ApiEndPoints.DOMAIN,
      options,
    );
    _socket = IO.io(ApiEndPoints.DOMAIN, options);
}

  IO.Socket get socket => _socket;
  void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }
  /// Gửi tin nhắn
  void sendMessage(dynamic params) {
    if (!isConnected) {
      log('⚠️ Socket not connected');
      return;
    }
    _socket.emit('send_message', params);
  }

  /// Khi user bắt đầu gõ
  void startTyping(int conversationId) {
    log('⚠️ user_typing : ');
    _socket.emit('typing_start', {'conversation_id': conversationId});
  }

  /// Khi user dừng gõ
  void stopTyping(int conversationId) {
    log('⚠️ user_stop_typing : ');
    _socket.emit('typing_stop', {'conversation_id': conversationId});
  }

  /// Đánh dấu tin nhắn đã đọc
  void markMessageAsRead(int messageId, int conversationId) {
    _socket.emit('message_read', {
      'message_id': messageId,
      'conversation_id': conversationId,
    });
  }

  /// Đánh dấu tất cả tin nhắn trong hội thoại đã đọc
  void markConversationAsRead(int conversationId) {
    _socket.emit('conversation_read', {'conversation_id': conversationId});
  }

  /// Join phòng chat cụ thể
  void joinConversation(int conversationId) {
    _socket.emit('join_conversation', {'conversation_id': conversationId});
  }

  /// Leave phòng chat
  void leaveConversation(int conversationId) {
    _socket.emit('leave_conversation', {'conversation_id': conversationId});
  }

  /// Lấy trạng thái online của users
  void updateUserStatus(String status) {
    _socket.emit('update_status', {'status': status});
  }

  /// Lấy trạng thái online của users
  void getUsersOnine(int conversationId) {
    log('⚠️ get_online_users : ');
    _socket.emit('get_online_users', {'conversation_id': conversationId});
  }

  /// Ngắt kết nối
  void disconnect() {
    _socket.disconnect();
    _socket.emit('disconnect',);

    // _connectionController.add(false);
    log('🔌 Socket disconnected manually');
  }

  Future<void> dispose() async {
    log("🧹 Disposing old socket...");
    _socket.clearListeners();
    try {
      _socket.disconnect();
      _socket.close();
      log("🧹 Disposing old socket...2");
    } catch (_) {}
    log("🧹 Socket cleared!");
  }
}
