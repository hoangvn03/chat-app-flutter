import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsSuccess extends ConversationsState {
  final ConversationResponse? data;
  final UserModel? userModel;
  final String? message;

  /// id của conversation đang được chọn
  final int? selectedConversationId;

  ConversationsSuccess({
    this.data,
    this.userModel,
    this.message,
    this.selectedConversationId,
  });

  ConversationsSuccess copyWith({
    ConversationResponse? data,
    UserModel? userModel,
    String? message,
    int? selectedConversationId,
  }) {
    return ConversationsSuccess(
      data: data ?? this.data,
      userModel: userModel ?? this.userModel,
      message: message ?? this.message,
      selectedConversationId:
          selectedConversationId ?? this.selectedConversationId,
    );
  }
}



class ConversationsFailure extends ConversationsState {
  String errorMessage;
  ConversationsFailure(this.errorMessage);
}
