import 'package:photo_manager/photo_manager.dart';

abstract class MediaPickedState {}

class MediaPickedLoading extends MediaPickedState {}

class MediaPickedSuccess extends MediaPickedState {
  final List<AssetPathEntity> album;
  final List<AssetEntity> asset;
  final List<AssetEntity>? selectedAsset;
  final AssetPathEntity? selectedAlbum;
  final String? nameRequestType;
  final String? errorMessage;
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

  MediaPickedSuccess copyWith({
    List<AssetPathEntity>? album,
    List<AssetEntity>? asset,
    List<AssetEntity>? selectedAsset,
    AssetPathEntity? selectedAlbum,
    String? nameRequestType,
    String? errorMessage,
    bool? isSelecting,
  }) {
    return MediaPickedSuccess(
      album: album ?? this.album,
      asset: asset ?? this.asset,
      selectedAsset: selectedAsset ?? this.selectedAsset,
      selectedAlbum: selectedAlbum ?? this.selectedAlbum,
      nameRequestType: nameRequestType ?? this.nameRequestType,
      errorMessage: errorMessage ?? this.errorMessage,
      isSelecting: isSelecting ?? this.isSelecting,
    );
  }
}


class MediaPickedFailure extends MediaPickedState {
  final String errorMessage;
  MediaPickedFailure(this.errorMessage);
}
