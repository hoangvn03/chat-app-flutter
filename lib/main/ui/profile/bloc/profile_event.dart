import 'package:chat_app/main/networks/model/user.dart';

abstract class ProfileEvent {}

class LoadRequest extends ProfileEvent {}

class DeletetUser extends ProfileEvent {
  final int userId;
  DeletetUser(this.userId);
}

class UpdateUser extends ProfileEvent {
  final UserModel user;
  UpdateUser(this.user);
}
