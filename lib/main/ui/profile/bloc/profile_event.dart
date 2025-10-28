import 'package:chat_app/main/networks/model/user.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
}
class LoadProfileUserContact extends ProfileEvent {
  int id;
  LoadProfileUserContact(this.id);
}

class ClearStrogeUser extends ProfileEvent {
}

class UpdateUser extends ProfileEvent {
  final UserModel user;
  UpdateUser(this.user);
}
