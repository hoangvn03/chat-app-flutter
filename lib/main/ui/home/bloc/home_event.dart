import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class HomeEvent {}

class LoadRequest extends HomeEvent {}

class GetNotificationCount extends HomeEvent {
  final int num;
  GetNotificationCount(this.num);
}

class UpdateStatusUsers extends HomeEvent {
  final String status;
  final bool isInit;
  UpdateStatusUsers({required this.status,required this.isInit});
}