import 'package:chat_app/main/networks/model/user.dart';

abstract class CreateChatEvent {}

class LoadMessage extends CreateChatEvent {
    final int conversationId;
  LoadMessage(this.conversationId);
}
class CreateNewChat extends CreateChatEvent {
  final bool isGroup;
  final String? converationName; 
  final List<int> participantIds;
  CreateNewChat({this.isGroup = false, this.converationName,required this.participantIds});
}

class AddUserToGroup extends CreateChatEvent {
  final UserModel user;
  AddUserToGroup(this.user);
}
class RemoveUserToGroup extends CreateChatEvent {
  final UserModel user;
  RemoveUserToGroup(this.user);
}

class LoadListUser extends CreateChatEvent {
  String input;
  LoadListUser(this.input);
}

