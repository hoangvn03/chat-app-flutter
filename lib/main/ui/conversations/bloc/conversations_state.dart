import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsSuccess extends ConversationsState {
  ConversationResponse? data;
  UserModel currentUser;
  ConversationsSuccess({this.data,required this.currentUser});
}

class ConversationsFailure extends ConversationsState {
  String errorMessage;
  ConversationsFailure(this.errorMessage);
}
