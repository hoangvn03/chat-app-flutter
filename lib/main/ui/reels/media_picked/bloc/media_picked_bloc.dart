import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/image/media_helper.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_state.dart';

import 'package:photo_manager/photo_manager.dart';

class MediaPickedBloc extends Bloc<MediaPickedEvent, MediaPickedState> {
  MediaPickedBloc() : super(MediaPickedLoading()) {
    on<LoadRequest>(_loadRequest);
    on<ChooseMedia>(_chooseMedia);
    on<ToggleSelectingMode>(_toggleSelectingMode); // ✅ thêm dòng này
  }
  List<AssetPathEntity> albumList = [];
  List<AssetPathEntity> albumAll = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<MediaPickedState> emit,
  ) async {
    try {
      albumList = await MediaHelper().loadAlbums(event.requestType);
      final selected = event.selectedAlbum ?? albumList.first;
      assetList = await MediaHelper().loadAssests(selected);
      if (assetList.isEmpty || albumList.isEmpty) {
        emit(MediaPickedFailure("Không có ảnh"));
        return;
      }
      emit(
        MediaPickedSuccess(
          album: albumList,
          asset: assetList,
          selectedAlbum: selected,
          nameRequestType: event.nameRequestType,
        ),
      );
    } catch (e) {
      if (assetList.isEmpty || albumList.isEmpty) {
        emit(MediaPickedFailure("Không có ảnh"));
        return;
      }
      emit(MediaPickedFailure(e.toString()));
    }
  }

  Future<void> _chooseMedia(
    ChooseMedia event,
    Emitter<MediaPickedState> emit,
  ) async {
    try {
      String? errorMessage;
      if (event.asset != null) {
        if (selectedAssetList.contains(event.asset)) {
          selectedAssetList.remove(event.asset);
        } else {
          if (selectedAssetList.length >= 10) {
            errorMessage = "Bạn chỉ được chọn tối đa 10 ảnh";
          } else {
            selectedAssetList.add(event.asset!);
          }
        }
      }

      emit(
        MediaPickedSuccess(
          album: albumList,
          asset: assetList,
          selectedAsset: selectedAssetList,
          errorMessage: errorMessage,
          isSelecting: event.isSelecting, // giữ trạng thái chọn
        ),
      );
    } catch (e) {
      emit(MediaPickedFailure(e.toString()));
    }
  }

  Future<void> _toggleSelectingMode(
    ToggleSelectingMode event,
    Emitter<MediaPickedState> emit,
  ) async {
    try {
      final data = selectedAssetList;
      // if (selectedAssetList.isNotEmpty) {
      //   data.clear();
      // }
      emit(
        MediaPickedSuccess(
          album: albumList,
          asset: assetList,
          selectedAsset: data,
          errorMessage: null,
          isSelecting: event.isSelecting,
        ),
      );
    } catch (e) {
      emit(MediaPickedFailure(e.toString()));
    }
  }
}
