import 'package:chat_app/main/networks/model/user.dart';

abstract class NotificationEvent {}

class LoadNotification extends NotificationEvent {
}
class LoadSeenUnSeenNitification extends NotificationEvent {
}
class LoadUnreadNotification extends NotificationEvent {
}
class CreateNotification extends NotificationEvent {
}

