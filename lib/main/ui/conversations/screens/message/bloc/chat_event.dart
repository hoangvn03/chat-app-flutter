import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ChatEvent {}

class LoadMessage extends ChatEvent {
  Conversation conversation;
  LoadMessage(this.conversation);
}

class LoadDetailConveration extends ChatEvent {
  int id;
  LoadDetailConveration(this.id);
}

class SendMessage extends ChatEvent {
  final int conversationId;
  final String message;
  SendMessage(this.conversationId, this.message);
}
class ReceiveMessage extends ChatEvent {
  final Map<String,dynamic> message;
  ReceiveMessage(this.message);
}

class UpdateUser extends ChatEvent {
  final UserModel user;
  UpdateUser(this.user);
}
