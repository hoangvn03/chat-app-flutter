import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

abstract class CreateReelsState {}

class CreateReelsLoading extends CreateReelsState {}

class CreateReelsLoadedVideo extends CreateReelsState {
  final VideoPlayerController controller;
  CreateReelsLoadedVideo({required this.controller});
}

class CreateReelsLoadedImage extends CreateReelsState {
  final AssetEntity asset;
  CreateReelsLoadedImage({required this.asset});
}

class CreateReelsError extends CreateReelsState {
  final String message;
  CreateReelsError(this.message);
}
