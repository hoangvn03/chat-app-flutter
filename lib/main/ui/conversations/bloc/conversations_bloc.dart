import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_event.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc() : super(ConversationsLoading()) {
    on<LoadRequest>(_loadListConversation);
  }

  Future<void> _loadListConversation(
    LoadRequest event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      var url = ApiEndPoints.CONVERATIONS;
      var params = {'page': '1', 'limit': '10'};
      print(url);
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final data = ConversationResponse.fromJson(res.body['data']);
        emit(
          ConversationsSuccess(
            data: data,
          ),
        );
      } else {
        emit(ConversationsFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(ConversationsFailure(e.toString()));
    }
    return;
  }
}
