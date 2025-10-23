import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class ListReelsEvent {}

class LoadReelsMedia extends ListReelsEvent {
  LoadReelsMedia();
}
class LoadListReels extends ListReelsEvent {
}

class ChooseMedia extends ListReelsEvent {
   AssetEntity? asset;

  ChooseMedia({this.asset});
}
