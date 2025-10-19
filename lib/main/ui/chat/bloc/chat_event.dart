import 'package:chat_app/main/networks/model/user.dart';

abstract class ChatEvent {}

class LoadRequest extends ChatEvent {}

class LoadDetailConveration extends ChatEvent {
  int id;
  LoadDetailConveration(this.id);
}

class SendMessage extends ChatEvent {
  final int conversationId;
  final String message;
  SendMessage(this.conversationId, this.message);
}

class UpdateUser extends ChatEvent {
  final UserModel user;
  UpdateUser(this.user);
}
