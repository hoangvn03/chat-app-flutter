
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsState {}
class CreateReelsLoading extends CreateReelsState {}
class CreateReelsSuccess extends CreateReelsState {
  List<AssetPathEntity> album;
  List<AssetEntity> asset;
  AssetPathEntity selectedAlbum;
  CreateReelsSuccess({required this.album,required this.asset,required this.selectedAlbum});
}
class CreateReelsFailure extends CreateReelsState {
  final String errorMessage;
    CreateReelsFailure(this.errorMessage);
}
