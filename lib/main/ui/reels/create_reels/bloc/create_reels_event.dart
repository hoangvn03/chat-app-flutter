import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsEvent {}

class LoadReelsMedia extends CreateReelsEvent {
  List<AssetEntity>? assetList;
  LoadReelsMedia({this.assetList});
}

class ChooseMedia extends CreateReelsEvent {
   AssetEntity? asset;

  ChooseMedia({this.asset});
}
