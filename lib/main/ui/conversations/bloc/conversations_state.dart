import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsSuccess extends ConversationsState {
  ConversationResponse? data;
  ConversationsSuccess({this.data});
}

class ConversationsFailure extends ConversationsState {
  String errorMessage;
  ConversationsFailure(this.errorMessage);
}
