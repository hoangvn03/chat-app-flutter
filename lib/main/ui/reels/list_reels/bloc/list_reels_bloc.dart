import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/media/media_helper.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/reels/list_reels/bloc/list_reels_event.dart';
import 'package:chat_app/main/ui/reels/list_reels/bloc/list_reels_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';

import 'package:photo_manager/photo_manager.dart';

class ListReelsBloc extends Bloc<ListReelsEvent, ListReelsState> {
  ListReelsBloc() : super(ListReelsLoading()) {
    on<LoadReelsMedia>(_loadRequest);
    on<LoadListReels>(_loadListStory);
  }
  List<AssetPathEntity> albumList = [];
  List<AssetPathEntity> albumAll = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  Future<void> _loadRequest(
    LoadReelsMedia event,
    Emitter<ListReelsState> emit,
  ) async {
    final UserModel user = UserModel( id:999,

      username: 'John Doe',
      avatar: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
    );
    final List<ReelModel> stories = [
      ReelModel(
        url:
            'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
        media: MediaType.image,
        duration: const Duration(seconds: 10),
        user: user,
      ),
      ReelModel(
        url: 'https://media.giphy.com/media/moyzrwjUIkdNe/giphy.gif',
        media: MediaType.image,
        user: UserModel( id:999,

          username: 'John Doe',
          avatar: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
        ),
        duration: const Duration(seconds: 7),
      ),
      ReelModel(
        url:
            'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
        media: MediaType.video,
        duration: const Duration(seconds: 0),
        user: user,
      ),
      ReelModel(
        url:
            'https://images.unsplash.com/photo-1531694611353-d4758f86fa6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
        media: MediaType.image,
        duration: const Duration(seconds: 5),
        user: user,
      ),
      ReelModel(
        url:
            'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
        media: MediaType.video,
        duration: const Duration(seconds: 0),
        user: user,
      ),
      ReelModel(
        url: 'https://media2.giphy.com/media/M8PxVICV5KlezP1pGE/giphy.gif',
        media: MediaType.image,
        duration: const Duration(seconds: 8),
        user: user,
      ),
    ];
    
    
    emit(ListReelsSuccess());
  }

  Future<void> _loadListStory(
    LoadListReels event,
    Emitter<ListReelsState> emit,
  ) async {
    emit(ListReelsLoading());
    var url = ApiEndPoints.LISTSTORY;
    var params = {
      "msisdn": "+67076796381",
      "timestamp": "12283842983",
      "security":
          "Pktc6GbmXot%2BRwhbxPLvBU8hdd092XXgaoS6H2WhTg5f5jzToF1ooF1iuXRH1vL2mgFOppO7TmCRndy%2B45rCVcoPOou2YEBBxxQ61XcOAJXlVSOZeA3sjx0gC3BpoqvZShQcDFtggIDi3VqM6GIsuP18xYpRB4snkT23N6Vx%2FWs%3D",
      "page": "0",
      "size": "10",
    };
    ApiResponse res = await ApiUtil.get(url,params: params);
    if (res.statusCode == 200) {
      
      emit(ListReelsSuccess());
    } else {
      emit(
        ListReelsFailure(
          'Error ${res.statusCode}: ${res.body?['message'] ?? 'Unknown'}',
        ),
      );
    }
  }
}
