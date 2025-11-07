import 'dart:io';

import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsEvent {}

class LoadReelsMedia extends CreateReelsEvent {
  List<dynamic> assetList;
  LoadReelsMedia(this.assetList);
}
class UploadFileMedia extends CreateReelsEvent{
  String typeMedia;
  String content;
  List<File> fileMedia;
  UploadFileMedia(this.typeMedia,this.fileMedia,this.content);
}
class UploadReels extends CreateReelsEvent{
  String typeMedia;
  String content;
  File fileMedia;
  String id;
  MediaOverlay? overlay;
  UploadReels(this.typeMedia,this.fileMedia,this.content,this.id,{this.overlay});
}
class EditTextStory extends CreateReelsEvent {
  final MediaOverlay overlay;
  EditTextStory(this.overlay);
}
