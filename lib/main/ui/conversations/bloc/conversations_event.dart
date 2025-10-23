import 'package:chat_app/main/networks/model/user.dart';

abstract class ConversationsEvent {}

class LoadRequest extends ConversationsEvent {}

class LoadDetailConveration extends ConversationsEvent {
  int id;
  LoadDetailConveration(this.id);
}

class SendMessage extends ConversationsEvent {
  final int conversationId;
  final String message;
  SendMessage(this.conversationId, this.message);
}

class UpdateUser extends ConversationsEvent {
  final UserModel user;
  UpdateUser(this.user);
}
