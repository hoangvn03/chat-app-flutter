import 'dart:io';

import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsEvent {}

class LoadReelsMedia extends CreateReelsEvent {
  List<dynamic> assetList;
  LoadReelsMedia(this.assetList);
}

class UploadFileMedia extends CreateReelsEvent {
  String typeMedia;
  String content;
  List<File> fileMedia;
  UploadFileMedia(this.typeMedia, this.fileMedia, this.content);
}

class UploadReels extends CreateReelsEvent {
  String typeMedia;
  String content;
  String id;
  AssetEntity? sticker;
  int indexFilter;
  MediaOverlay? overlay;
  UploadReels(
    this.typeMedia,
    this.content,
    this.id, {
    this.sticker,
    this.overlay,
    this.indexFilter = -1,
  });
}

class EditTextStory extends CreateReelsEvent {
  final MediaOverlay overlay;
  EditTextStory(this.overlay);
}

class ToggleHeaderIcons extends CreateReelsEvent {
  final bool visible;
  ToggleHeaderIcons(this.visible);
}

class ChangeFilterMedia extends CreateReelsEvent {
  final int index;
  final PageController pageController;
  ChangeFilterMedia({required this.index, required this.pageController});
}

class AddMediaItem extends CreateReelsEvent {
  final String mediapath;
  final AssetEntity item;
  AddMediaItem(this.mediapath, this.item);
}

class UpdateOverlayPosition extends CreateReelsEvent {
  final double x;
  final double y;

  UpdateOverlayPosition({required this.x, required this.y});
}
