import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class CreateChatState {}

class CreateChatLoading extends CreateChatState {}

class CreateChatSuccess extends CreateChatState {
  final List<MessageEntity>? messages;
  final List<UserModel>? users;
  final List<UserModel>? members;
  final int? conversationId;

  CreateChatSuccess({
    this.messages,
    this.conversationId,
    this.users,
    this.members,
  });

  CreateChatSuccess copyWith({
    List<MessageEntity>? messages,
    List<UserModel>? users,
    List<UserModel>? members,
    int? conversationId,
  }) {
    return CreateChatSuccess(
      messages: messages ?? this.messages,
      users: users ?? this.users,
      members: members ?? this.members,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

class CreateChatFailure extends CreateChatState {
  final String errorMessage;

  CreateChatFailure(this.errorMessage);
}
