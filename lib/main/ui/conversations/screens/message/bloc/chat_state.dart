import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageEntity> messages;
  final List<UserModel>? typingUsers;
  final List<UserModel>? onlineUsers;
  final List<dynamic>? file;
  final String? statusMessage;
  final Map<int, String> userStatuses; // user_id -> status
  final StatusUser statusUserContact;

  ChatSuccess({
    required this.messages,
    this.typingUsers = const [],
    this.onlineUsers = const [],
    this.statusMessage = '',
    this.file = const [],
    this.userStatuses = const {},
    this.statusUserContact = StatusUser.offline,
  });

  ChatSuccess copyWith({
    List<MessageEntity>? messages,
    List<UserModel>? typingUsers,
    List<UserModel>? onlineUsers,
    List<dynamic>? file,
    String? statusMessage,
    Map<int, String>? userStatuses,
    StatusUser? statusUserContact,
  }) {
    return ChatSuccess(
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      onlineUsers: onlineUsers ?? this.onlineUsers,
      file: file ?? this.file,
      statusMessage: statusMessage ?? this.statusMessage,
      userStatuses: userStatuses ?? this.userStatuses,
      statusUserContact: statusUserContact ?? this.statusUserContact,
    );
  }
}

class ChatFailure extends ChatState {
  String errorMessage;
  String? errorCode;
  ChatFailure(this.errorMessage, {this.errorCode});
}
