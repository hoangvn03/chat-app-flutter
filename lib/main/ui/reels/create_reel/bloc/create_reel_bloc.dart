import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/image/media_helper.dart';
import 'package:chat_app/main/ui/reels/create_reel/bloc/create_reel_event.dart';
import 'package:chat_app/main/ui/reels/create_reel/bloc/create_reel_state.dart';

import 'package:photo_manager/photo_manager.dart';

class CreateReelsBloc extends Bloc<CreateReelsEvent, CreateReelsState> {
  CreateReelsBloc() : super(CreateReelsLoading()) {
    on<LoadRequest>(_loadRequest);
  }
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<CreateReelsState> emit,
  ) async {
    try {
      albumList = await MediaHelper().loadAlbums(event.requestType);
      final selected = event.selectedAlbum ?? albumList.first;
        assetList = await MediaHelper().loadAssests(selected);

      // if (event.selectedAlbum != null) {
      //   assetList = await MediaHelper().loadAssests(selected);
      // } else {
      //   event.selectedAlbum = albumList[0];
      //   assetList = await MediaHelper().loadAssests(selected);
      // }
      if (assetList.isEmpty || albumList.isEmpty) {
        emit(CreateReelsFailure("Không có ảnh"));
        return;
      }
      emit(
        CreateReelsSuccess(
          album: albumList,
          asset: assetList,
          selectedAlbum: selected,
        ),
      );
    } catch (e) {
      if (assetList.isEmpty || albumList.isEmpty) {
        emit(CreateReelsFailure("Không có ảnh"));
        return;
      }
      emit(CreateReelsFailure(e.toString()));
    }
  }
}
