import 'dart:io';

import 'package:chat_app/main/networks/model/reels.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

abstract class CreateReelsState {}

class CreateReelsLoading extends CreateReelsState {}

class CreateReelsSuccess extends CreateReelsState {
  final AssetEntity? asset;
  final VideoPlayerController? controller;
  final String? id;
  final String? decs;
  final File? editedFile;
  final MediaOverlay? overlay;
  final AssetEntity? sticker;
  final bool isHideHeaderIcon;
  final int currentIndex;

  CreateReelsSuccess({
    this.asset,
    this.controller,
    this.id,
    this.decs,
    this.editedFile,
    this.overlay,
    this.isHideHeaderIcon = false,
    this.currentIndex = 0,
    this.sticker,
  });
  CreateReelsSuccess copyWith({
    AssetEntity? asset,
    VideoPlayerController? controller,
    String? id,
    AssetEntity? sticker,
    String? decs,
    File? editedFile,
    MediaOverlay? overlay,
    bool? isHideHeaderIcon,
    int? currentIndex,
  }) {
    return CreateReelsSuccess(
      asset: asset ?? this.asset,
      controller: controller ?? this.controller,
      id: id ?? this.id,
      sticker: sticker ?? this.sticker,
      decs: decs ?? this.decs,
      editedFile: editedFile ?? this.editedFile,
      overlay: overlay ?? this.overlay,
      isHideHeaderIcon: isHideHeaderIcon ?? this.isHideHeaderIcon,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class CreateReelsError extends CreateReelsState {
  final String message;
  CreateReelsError(this.message);
}
