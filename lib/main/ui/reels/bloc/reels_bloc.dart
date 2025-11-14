import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/reels/bloc/reels_event.dart';
import 'package:chat_app/main/ui/reels/bloc/reels_state.dart';

import 'package:photo_manager/photo_manager.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  ReelsBloc() : super(ReelsLoading()) {
    on<LoadReelsMedia>(_loadRequest);
    on<LoadReels>(_loadListStory);
  }
  List<AssetPathEntity> albumList = [];
  List<AssetPathEntity> albumAll = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  Future<void> _loadRequest(
    LoadReelsMedia event,
    Emitter<ReelsState> emit,
  ) async {
    var url = '${ApiEndPoints.LOADPOST}';
    var params = {'page': '1', 'limit': '10'};
    ApiResponse res = await ApiUtil.get(url, params: params);
    if (res.statusCode == 200) {
      final data =
          (res.body['data']['posts'] as List)
              .map((e) => PostModel.fromJson(e))
              .toList();
      if (state is ReelsSuccess) {
        final current = state as ReelsSuccess;
        emit(current.copyWith(posts: data));
      } else {
        emit(ReelsSuccess(posts: data));
      }
    } else {
      emit(ReelsFailure('${res.statusCode} Fail to load api'));
    }
  }

  Future<void> _loadListStory(LoadReels event, Emitter<ReelsState> emit) async {
    emit(ReelsLoading());
    var url = ApiEndPoints.LISTSTORY;
    var params = {
      "msisdn": "+67076796381",
      "timestamp": "12283842983",
      "security":
          "Pktc6GbmXot%2BRwhbxPLvBU8hdd092XXgaoS6H2WhTg5f5jzToF1ooF1iuXRH1vL2mgFOppO7TmCRndy%2B45rCVcoPOou2YEBBxxQ61XcOAJXlVSOZeA3sjx0gC3BpoqvZShQcDFtggIDi3VqM6GIsuP18xYpRB4snkT23N6Vx%2FWs%3D",
      "page": "0",
      "size": "10",
    };
    ApiResponse res = await ApiUtil.get(url, params: params);
    if (res.statusCode == 200) {
      emit(ReelsSuccess());
    } else {
      emit(
        ReelsFailure(
          'Error ${res.statusCode}: ${res.body?['message'] ?? 'Unknown'}',
        ),
      );
    }
  }
}
