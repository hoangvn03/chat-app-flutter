
abstract class AuthEvent {}

class Login extends AuthEvent {
  final String username;
  final String password;

  Login( this.username, this.password);
}
class UpdateStatusUsers extends AuthEvent {
  final String status;
  final bool isInit;
  UpdateStatusUsers({required this.status,required this.isInit});
}
class Logout extends AuthEvent {
}
class CheckUser extends AuthEvent {
}