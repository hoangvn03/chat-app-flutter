import 'package:chat_app/main/networks/model/user.dart';

abstract class SettingEvent {}

class LoadRequest extends SettingEvent {
  
}

class ClearStrogeUser extends SettingEvent {
}

class UpdateUser extends SettingEvent {
  final UserModel user;
  UpdateUser(this.user);
}
