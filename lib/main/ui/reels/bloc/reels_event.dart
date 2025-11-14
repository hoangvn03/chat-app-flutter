import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class ReelsEvent {}

class LoadReelsMedia extends ReelsEvent {
  LoadReelsMedia();
}
class LoadReels extends ReelsEvent {
}

class ChooseMedia extends ReelsEvent {
   AssetEntity? asset;

  ChooseMedia({this.asset});
}
