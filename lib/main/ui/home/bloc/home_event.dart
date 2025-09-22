import 'package:chat_app/main/networks/model/user.dart';

abstract class HomeEvent {}

class LoadListUser extends HomeEvent {}
class LoadListReel extends HomeEvent {}

class DeletetUser extends HomeEvent {
  final int userId;
  DeletetUser(this.userId);
}

class UpdateUser extends HomeEvent {
  final UserModel user;
  UpdateUser(this.user);
}
