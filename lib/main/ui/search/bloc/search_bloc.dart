import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/search/bloc/search_event.dart';
import 'package:chat_app/main/ui/search/bloc/search_state.dart';
import 'package:chat_app/res/app_images.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchLoading()) {
    on<LoadRequest>(_loadRequest);
    on<PressInputSearch>(_searchRequest);
  }
  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<SearchState> emit,
  ) async {
    try {
      var url = ApiEndPoints.LOADPOST;
      var params = {'page': '1', 'limit': '10'};
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final data =
            (res.body['data']['posts'] as List)
                .map((e) => PostModel.fromJson(e))
                .toList();
        if (state is SearchSuccess) {
          final current = state as SearchSuccess;
          emit(current.copyWith(posts: data));
        } else {
          emit(SearchSuccess(posts: data));
        }
      } else {
        emit(SearchFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
    return;
  }

  Future<void> _searchRequest(
    PressInputSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      var url = ApiEndPoints.USERS;
      var params = {'page': '1', 'limit': '10', 'search': event.input};
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final data = UserResponse.fromJson(res.body['data']);
        if (state is SearchSuccess) {
          final current = state as SearchSuccess;
          emit(current.copyWith(users: data.users));
        } else {
          emit(SearchSuccess(users: data.users));
        }
      } else {
        emit(SearchFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}
