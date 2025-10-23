import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/image/media_helper.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_state.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class CreateReelsBloc extends Bloc<CreateReelsEvent, CreateReelsState> {
  CreateReelsBloc() : super(CreateReelsLoading()) {
    on<LoadReelsMedia>(_loadMediaPicked);
  }
  Future<void> _loadMediaPicked(
    LoadReelsMedia event,
    Emitter<CreateReelsState> emit,
  ) async {
    try {
      emit(CreateReelsLoading());

      final mediaPicked = event.assetList.first;

      // Nếu là video
      if (mediaPicked.type == AssetType.video) {
        final File? file = await mediaPicked.originFile;

        if (file != null) {
          final controller = VideoPlayerController.file(file);
          await controller.initialize();
          controller.play();

          emit(CreateReelsLoadedVideo(controller: controller));
        } else {
          emit(CreateReelsError("Không thể lấy file video."));
        }
      }
      // Nếu là ảnh
      else if (mediaPicked.type == AssetType.image) {
        emit(CreateReelsLoadedImage(asset: mediaPicked));
      } else {
        emit(CreateReelsError("Loại file không được hỗ trợ."));
      }
    } catch (e) {
      emit(CreateReelsError(e.toString()));
    }
  }
  
}
