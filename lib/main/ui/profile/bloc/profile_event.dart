import 'package:chat_app/main/networks/model/user.dart';

abstract class ProfileEvent {}

class LoadRequest extends ProfileEvent {
  
}

class ClearStrogeUser extends ProfileEvent {
}

class UpdateUser extends ProfileEvent {
  final UserModel user;
  UpdateUser(this.user);
}
