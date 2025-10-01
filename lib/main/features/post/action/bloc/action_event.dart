import 'package:chat_app/main/networks/model/user.dart';

abstract class ActionEvent {}

class LoadRequest extends ActionEvent {}

class DeletetUser extends ActionEvent {
  final int userId;
  DeletetUser(this.userId);
}

class UpdateUser extends ActionEvent {
  final UserModel user;
  UpdateUser(this.user);
}
