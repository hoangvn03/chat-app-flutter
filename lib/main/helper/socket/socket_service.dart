import 'dart:async';
import 'dart:developer';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  late IO.Socket _socket;

  // Stream controllers cho các sự kiện realtime
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _userStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messageReadController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  SocketService._internal() {
    initSocket();
  }

  bool get isConnected => _socket.connected;

  // Các stream để lắng nghe từ UI
  Stream<Map<String, dynamic>> get onMessageReceived =>
      _messageController.stream;
  Stream<Map<String, dynamic>> get onTypingEvent => _typingController.stream;
  Stream<Map<String, dynamic>> get onUserStatusChanged =>
      _userStatusController.stream;
  Stream<Map<String, dynamic>> get onMessageRead =>
      _messageReadController.stream;
  Stream<Map<String, dynamic>> get onNotification =>
      _notificationController.stream;
  Stream<bool> get onConnectionStatusChanged => _connectionController.stream;

  Future<void> initSocket() async {
    final token = await AppStorage.getToken();
    _socket = IO.io(
      ApiEndPoints.DOMAIN,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({"Authorization": "Bearer $token"})
          .setAuth({'token': token})
          .build(),
    );

    _setupSocketListeners();
    _socket.connect();
  }

  IO.Socket get socket => _socket;

  void _setupSocketListeners() {
    _socket.onConnect((_) {
      log('✅ Connected to Socket.IO server : ${_socket.id}');
      _connectionController.add(true);
    });

    _socket.onDisconnect((reason) {
      log('❌ Socket Disconnected: $reason');
      _connectionController.add(false);
    });

    _socket.onError((error) {
      log('⚠️ Socket error: $error');
    });

    _socket.onConnectError((error) {
      log('⚠️ Connection error: $error');
    });

    // Tin nhắn mới
    _socket.on('new_message', (data) {
      log('💬 New message: $data');
      _messageController.add(Map<String, dynamic>.from(data));
    });

    // User typing
    _socket.on('user_typing', (data) {
      log('⌨️ User typing: $data');
      _typingController.add(Map<String, dynamic>.from(data));
    });

    _socket.on('user_stop_typing', (data) {
      log('⏹️ User stop typing: $data');
      _typingController.add({
        ...Map<String, dynamic>.from(data),
        'is_typing': false,
      });
    });

    // User status changed
    _socket.on('user_status_changed', (data) {
      log('👤 User status changed: $data');
      _userStatusController.add(Map<String, dynamic>.from(data));
    });

    // Message read
    _socket.on('message_read', (data) {
      log('📖 Message read: $data');
      _messageReadController.add(Map<String, dynamic>.from(data));
    });

    // Notifications
    _socket.on('unread_notifications_count', (data) {
      log('🔔 Unread notifications: $data');
      _notificationController.add(Map<String, dynamic>.from(data));
    });

    // New notification
    _socket.on('new_notification', (data) {
      log('🔔 New notification: $data');
      _notificationController.add(Map<String, dynamic>.from(data));
    });
  }

  /// Gửi tin nhắn
  void sendMessage(dynamic params) {
    if (!isConnected) {
      log('⚠️ Socket not connected');
      return;
    }

    _socket.emit('send_message', params);
  }

  /// Gửi tin nhắn file
  void sendFileMessage(
    int conversationId,
    String fileUrl,
    String fileName, {
    String? type = 'file',
  }) {
    if (!isConnected) return;

    _socket.emit('send_message', {
      'conversation_id': conversationId,
      'file_url': fileUrl,
      'file_name': fileName,
      'type': type,
      'content': 'Đã gửi một file',
    });
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

  // /// Tin nhắn mới
  // void newMessages(int conversationId) {
  //   _socket.emit('new_message', {'conversation_id': conversationId});
  // }

  /// Lấy trạng thái online của users
  void getUserStatuses(List<int> userIds) {
    _socket.emit('status_updated', {'user_ids': userIds});
  }
  

  /// Ngắt kết nối
  void disconnect() {
    _socket.disconnect();
    _connectionController.add(false);
    log('🔌 Socket disconnected manually');
  }

  // Cleanup
  void dispose() {
    _messageController.close();
    _typingController.close();
    _userStatusController.close();
    _messageReadController.close();
    _notificationController.close();
    _connectionController.close();
  }
}
