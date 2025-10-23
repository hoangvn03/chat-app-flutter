import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageEntity> messages;
  final List<String>? userOnline;
  ChatSuccess({this.messages = const [],this.userOnline});
  ChatSuccess copyWith({
    List<MessageEntity>? messages,
  }) {
    return ChatSuccess(
      messages: messages ?? this.messages,
      userOnline: userOnline ?? []
    );
  }
}


class ChatFailure extends ChatState {
  String errorMessage;
  ChatFailure(this.errorMessage);
}
