import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/media/ffmpeg_helper.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_state.dart';
import 'package:chat_app/main/utils/common_function.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class CreateReelsBloc extends Bloc<CreateReelsEvent, CreateReelsState> {
  CreateReelsBloc() : super(CreateReelsLoading()) {
    on<LoadReelsMedia>(_loadMediaPicked);
    on<UploadReels>(_upLoadReels);
    on<UploadFileMedia>(_upLoadFileMedia);
    on<EditTextStory>(_editText);
  }
  List<dynamic> _mediaPicked = [];
  Future<void> _loadMediaPicked(
    LoadReelsMedia event,
    Emitter<CreateReelsState> emit,
  ) async {
    try {
      emit(CreateReelsLoading());
      _mediaPicked = event.assetList;
      final mediaPicked = event.assetList.first;
      // final File? file = await FFmpegHelper.processMediaForStory(mediaPicked);
      // Nếu là video
      if (mediaPicked.type == AssetType.video) {
        final File? file = await mediaPicked.originFile;

        if (file != null) {
          final controller = VideoPlayerController.file(file);
          await controller.initialize();
          controller.play();
          emit(CreateReelsSuccess(controller: controller));
        } else {
          emit(CreateReelsError("Không thể lấy file video."));
        }
      }
      // Nếu là ảnh
      else if (mediaPicked.type == AssetType.image) {
        emit(CreateReelsSuccess(asset: mediaPicked));
      } else {
        emit(CreateReelsError("Loại file không được hỗ trợ."));
      }
    } catch (e) {
      emit(CreateReelsError(e.toString()));
    }
  }

  Future<void> _upLoadFileMedia(
    UploadFileMedia event,
    Emitter<CreateReelsState> emit,
  ) async {
    if (state is! CreateReelsSuccess) return;
    final currentState = state as CreateReelsSuccess;
    try {
      emit(CreateReelsLoading());
      // final files = await convertAssetEntitiesToFiles(event.fileMedia);

      final url = 'https://timordev.ringme.vn/RingMeAPI/story/uploadStoryFile';
      final Map<String, dynamic> body = {
        "token": '123abb1221c123b13',
        "msisdn": '+67076796381',
        "type": event.typeMedia,
        "uploadfile": event.fileMedia,
        "content": event.content,
        "timestamp": '1665799800000',
        "security":
            'Pktc6GbmXot%2BRwhbxPLvBU8hdd092XXgaoS6H2WhTg5f5jzToF1ooF1iuXRH1vL2mgFOppO7TmCRndy%2B45rCVcoPOou2YEBBxxQ61XcOAJXlVSOZeA3sjx0gC3BpoqvZShQcDFtggIDi3VqM6GIsuP18xYpRB4snkT23N6Vx%2FWs%3D',
      };
      ApiResponse res = await ApiUtil.postFileV2(url: url, data: body);
      if (res.statusCode == 200) {
        final data = UploadResponse.fromJson(res.body);
        emit(currentState.copyWith(id: data.id));
      }
    } catch (e) {
      emit(CreateReelsError(e.toString()));
    }
  }

  Future<void> _upLoadReels(
    UploadReels event,
    Emitter<CreateReelsState> emit,
  ) async {
    if (state is! CreateReelsSuccess) return;
    final currentState = state as CreateReelsSuccess;
    try {
      final File? file = await FFmpegHelper.processMediaForStory(
        _mediaPicked.first,
        overlay: event.overlay,
      );
      emit(currentState.copyWith(editedFile: file));

      // emit(CreateReelsLoading());
      // final url = 'https://timordev.ringme.vn/RingMeAPI/story/uploadStory';
      // final Map<String, dynamic> body = {
      //   "msisdn": '+67076796381',
      //   "file_ids": event.id,
      //   "timestamp": '1665799800000',
      //   "security":
      //       'Pktc6GbmXot%2BRwhbxPLvBU8hdd092XXgaoS6H2WhTg5f5jzToF1ooF1iuXRH1vL2mgFOppO7TmCRndy%2B45rCVcoPOou2YEBBxxQ61XcOAJXlVSOZeA3sjx0gC3BpoqvZShQcDFtggIDi3VqM6GIsuP18xYpRB4snkT23N6Vx%2FWs%3D',
      // };
      // ApiResponse res = await ApiUtil.postFileV2(url: url, data: body);
      // if (res.statusCode == 200) {
      //   final data = res.body['desc'];
      //   emit(currentState.copyWith(decs: data));
      // }
    } catch (e) {
      emit(CreateReelsError(e.toString()));
    }
  }

  Future<void> _editText(
    EditTextStory event,
    Emitter<CreateReelsState> emit,
  ) async {
    if (state is! CreateReelsSuccess) return;
    final currentState = state as CreateReelsSuccess;
    try {
      emit(currentState.copyWith(overlay: event.overlay));
    } catch (e) {
      emit(CreateReelsError(e.toString()));
    }
  }
}
