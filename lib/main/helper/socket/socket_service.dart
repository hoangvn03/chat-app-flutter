import 'dart:developer';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  late IO.Socket _socket;

  SocketService._internal() {
    initSocket();
  }
    bool get isConnected => _socket.connected ?? false;

  Future<void> initSocket() async {
    final token = await AppStorage.getToken();
        _socket = IO.io(
      ApiEndPoints.DOMAIN, // 🔥 thay bằng IP server backend Node.js của bạn
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({"Authorization": "Bearer $token",})
          .setAuth({'token': token}) // gửi token lên server để xác thực
          .build(),
    );

    _socket.onConnect((_) {
      print('✅ Connected to Socket.IO server : ${_socket.id}');
    });

    _socket.onDisconnect((reason) {
      print('❌ Socket Disconnected: $reason');
    });

    _socket.onError((error) {
      log('⚠️ Socket error: $error');
    });

    _socket.onConnectError((error) {
      log('⚠️ Connection error: $error');
    });

    // Khi có tin nhắn mới
    _socket.on('new_message', (data) {
      log('💬 New message: $data');
      // bạn có thể broadcast cho ChatBloc hoặc StreamController ở đây
    });

    // Khi user thay đổi trạng thái (online/offline)
    _socket.on('user_status_changed', (data) {
      log('👤 User status changed: $data');
    });

    // Số lượng thông báo chưa đọc
    _socket.on('unread_notifications_count', (data) {
      log('🔔 Unread notifications: ${data['count']}');
    });

    _socket.connect();
  }
  
  IO.Socket get socket => _socket;

  /// Kết nối Socket.IO với token JWT
  void connect(String token) {
    if (_socket != null && _socket.connected) {
      log('⚡ Socket already connected');
      return;
    }

    _socket = IO.io(
      'http://YOUR_SERVER_IP:3000', // 🔥 thay bằng IP server backend Node.js của bạn
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token}) // gửi token lên server để xác thực
          .build(),
    );

    _socket.onConnect((_) {
      log('✅ Connected to Socket.IO server');
    });

    _socket.onDisconnect((reason) {
      log('❌ Disconnected: $reason');
    });

    _socket.onError((error) {
      log('⚠️ Socket error: $error');
    });

    _socket.onConnectError((error) {
      log('⚠️ Connection error: $error');
    });

    // Khi có tin nhắn mới
    _socket.on('new_message', (data) {
      log('💬 New message: $data');
      // bạn có thể broadcast cho ChatBloc hoặc StreamController ở đây
    });

    // Khi user thay đổi trạng thái (online/offline)
    _socket.on('user_status_changed', (data) {
      log('👤 User status changed: $data');
    });

    // Số lượng thông báo chưa đọc
    _socket.on('unread_notifications_count', (data) {
      log('🔔 Unread notifications: ${data['count']}');
    });

    _socket.connect();
  }

  /// Gửi tin nhắn
  void sendMessage(int conversationId, String content) {
    if (!isConnected) {
      log('⚠️ Socket not connected');
      return;
    }

    _socket.emit('send_message', {
      'conversation_id': conversationId,
      'content': content,
    });
  }

  /// Khi user bắt đầu gõ
  void startTyping(int conversationId) {
    _socket.emit('typing_start', {'conversation_id': conversationId});
  }

  /// Khi user dừng gõ
  void stopTyping(int conversationId) {
    _socket.emit('typing_stop', {'conversation_id': conversationId});
  }

  /// Đánh dấu tin nhắn đã đọc
  void markMessageAsRead(int messageId) {
    _socket.emit('message_read', {'message_id': messageId});
  }

  /// Join phòng chat cụ thể
  void joinConversation(int conversationId) {
    _socket.emit('join_conversation', {'conversation_id': conversationId});
  }

  /// Leave phòng chat
  void leaveConversation(int conversationId) {
    _socket.emit('leave_conversation', {'conversation_id': conversationId});
  }

  /// Ngắt kết nối
  void disconnect() {
    _socket.disconnect();
    log('🔌 Socket disconnected manually');
  }
}
