import 'package:chat_app/main/networks/model/user.dart';

abstract class ChatEvent {}

class LoadRequest extends ChatEvent {}

class DeletetUser extends ChatEvent {
  final int userId;
  DeletetUser(this.userId);
}

class UpdateUser extends ChatEvent {
  final UserModel user;
  UpdateUser(this.user);
}
