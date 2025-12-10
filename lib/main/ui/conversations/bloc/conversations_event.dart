import 'dart:io';

import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ConversationsEvent {}

class LoadRequest extends ConversationsEvent {}

class LoadDetailConveration extends ConversationsEvent {
  int id;
  LoadDetailConveration(this.id);
}

class SendMessage extends ConversationsEvent {
  final int conversationId;
  final List<String> paths;
  final String message;
  SendMessage(this.conversationId, this.message,this.paths);
}
class ShareMediaFile extends ConversationsEvent {
  final List<String> paths;
  final int messageId;
  ShareMediaFile(this.paths,this.messageId);
}

class ChooseConveration extends ConversationsEvent {
  final int conversationId;

  ChooseConveration(this.conversationId);
}
class ClearMessage extends ConversationsEvent {}

