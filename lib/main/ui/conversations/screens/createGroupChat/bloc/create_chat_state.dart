import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class CreateChatState {}

class CreateChatLoading extends CreateChatState {}

class CreateChatSuccess extends CreateChatState {
  final List<UserModel>? users;
  final List<UserModel>? members;
  final bool isCreateSuccess;
  final bool isLoading;
  final Conversation? conversation;

  CreateChatSuccess({
    this.users,
    this.members,
    this.isCreateSuccess = false,
    this.isLoading = false,
    this.conversation,
  });

  CreateChatSuccess copyWith({
    List<UserModel>? users,
    List<UserModel>? members,
    bool? isCreateSuccess,
    bool? isLoading,
    Conversation? conversation,
  }) {
    return CreateChatSuccess(
      users: users ?? this.users,
      members: members ?? this.members,
      isCreateSuccess: isCreateSuccess ?? this.isCreateSuccess,
      isLoading: isLoading ?? this.isLoading,
      conversation: conversation ?? this.conversation,
    );
  }
}

class CreateChatFailure extends CreateChatState {
  final String errorMessage;
  int? erorCode;

  CreateChatFailure(this.errorMessage,{this.erorCode});
}
