import 'package:photo_manager/photo_manager.dart';

abstract class MediaPickedState {}

class MediaPickedLoading extends MediaPickedState {}

class MediaPickedSuccess extends MediaPickedState {
  List<AssetPathEntity> album;
  List<AssetEntity> asset;
  List<AssetEntity>? selectedAsset;
  AssetPathEntity? selectedAlbum;
  String? nameRequestType;
  String? errorMessage;
  bool? isSelecting;
  MediaPickedSuccess({
    required this.album,
    required this.asset,
    this.selectedAsset,
    this.selectedAlbum,
    this.nameRequestType,
    this.errorMessage,
    this.isSelecting,
  });
}

class MediaPickedFailure extends MediaPickedState {
  final String errorMessage;
  MediaPickedFailure(this.errorMessage);
}
