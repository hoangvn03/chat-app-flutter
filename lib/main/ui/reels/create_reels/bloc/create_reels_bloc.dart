import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/image/media_helper.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_state.dart';

import 'package:photo_manager/photo_manager.dart';

class CreateReelsBloc extends Bloc<CreateReelsEvent, CreateReelsState> {
  CreateReelsBloc() : super(CreateReelsLoading()) {
    on<LoadReelsMedia>(_loadMediaPicked);
  }
  List<AssetPathEntity> albumList = [];
  List<AssetPathEntity> albumAll = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  Future<void> _loadMediaPicked(
    LoadReelsMedia event,
    Emitter<CreateReelsState> emit,
  ) async {
    final mediaPicked  = event.assetList ??[];
  }
}
