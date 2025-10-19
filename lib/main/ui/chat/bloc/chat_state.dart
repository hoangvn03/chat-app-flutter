import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  ConversationResponse? data;
  MessageData? message;
  MessageModel? messageModel;
  ChatSuccess({this.data,this.message,this.messageModel});
}

class ChatFailure extends ChatState {
  String errorMessage;
  ChatFailure(this.errorMessage);
}
