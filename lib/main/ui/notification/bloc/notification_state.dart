import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationSuccess extends NotificationState {
}
class NotificationFailure extends NotificationState {
  String? erroMessage;
  NotificationFailure({this.erroMessage});
}
