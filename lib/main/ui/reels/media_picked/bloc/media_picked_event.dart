import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class MediaPickedEvent {}

class LoadRequest extends MediaPickedEvent {
  final int maxCount;
  final RequestType requestType;
  AssetPathEntity? selectedAlbum;
  String? nameRequestType;

  LoadRequest({
    required this.requestType,
    required this.maxCount,
    this.selectedAlbum,
    this.nameRequestType,
  });
}

class ToggleSelectingMode extends MediaPickedEvent {
  final bool isSelecting;
  ToggleSelectingMode({required this.isSelecting});
}

class ChooseMedia extends MediaPickedEvent {
  AssetEntity? asset;
  bool? isSelecting;

  ChooseMedia({this.asset, this.isSelecting});
}
