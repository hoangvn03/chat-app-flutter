import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_event.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_state.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../networks/api_util.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc() : super(ConversationsLoading()) {
    on<LoadRequest>(_loadListConversation);
    on<SendMessage>(_onSendMessage);
    on<ChooseConveration>(_onChooseConveration);
    on<ShareMediaFile>(_onShareMediaFile);
  }

  Future<void> _loadListConversation(
    LoadRequest event,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      emit(ConversationsLoading());

      final url = ApiEndPoints.CONVERATIONS;
      final params = {'page': '1', 'limit': '10'};
      final user = await AppStorage.getUser();

      final res = await ApiUtil.get(url, params: params);

      if (res.statusCode == 200 && res.body['data'] != null) {
        final data = ConversationResponse.fromJson(res.body['data']);

        emit(
          ConversationsSuccess(
            data: data,
            userModel: user,
            selectedConversationId: null,
          ),
        );
      } else {
        emit(ConversationsFailure("API Error: ${res.statusCode}"));
      }
    } catch (e) {
      emit(ConversationsFailure("Exception: $e"));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ConversationsState> emit,
  ) async {
    if (state is! ConversationsSuccess) return;

    final currentState = state as ConversationsSuccess;

    try {
      final String path = event.paths[0].toLowerCase();

      bool isImage =
          path.endsWith(".jpg") ||
          path.endsWith(".jpeg") ||
          path.endsWith(".png") ||
          path.endsWith(".gif") ||
          path.endsWith(".webp");

      bool isVideo =
          path.endsWith(".mp4") ||
          path.endsWith(".mov") ||
          path.endsWith(".avi") ||
          path.endsWith(".mkv");
      final url = ApiEndPoints.SENDMESSAGE;
      final params = {
        "content":
            isImage
                ? "${event.message}|Đã gửi 1 ảnh"
                : isVideo
                ? "${event.message}|Đã gửi 1 video"
                : event.message, // fallback
        "conversation_id": event.conversationId,
      };

      final res = await ApiUtil.post(url: url, data: params);
      print("MediaItem - Gửi URL Event:${event.paths[0]}");
      if (res.statusCode == 201) {
        final data = MessageEntity.fromJson(res.body['data']['message']);
        add(ShareMediaFile(event.paths, data.messageId));
        emit(currentState.copyWith(message: "Gửi tin nhắn thành công"));
      } else {
        emit(ConversationsFailure("Send API error: ${res.statusCode}"));
      }
    } catch (e) {
      emit(ConversationsFailure("Send error: $e"));
    }
  }

  Future<void> _onChooseConveration(
    ChooseConveration event,
    Emitter<ConversationsState> emit,
  ) async {
    if (state is! ConversationsSuccess) return;

    final current = state as ConversationsSuccess;
    final isSame = current.selectedConversationId == event.conversationId;

    emit(
      current.copyWith(
        selectedConversationId: isSame ? null : event.conversationId,
      ),
    );
  }

  Future<void> _onShareMediaFile(
    ShareMediaFile event,
    Emitter<ConversationsState> emit,
  ) async {
    if (state is! ConversationsSuccess) return;

    final current = state as ConversationsSuccess;
    List<File> files = await urlListToFileList(event.paths);
    final url = '${ApiEndPoints.SENDFILE}/${event.messageId}';
    final res = await ApiUtil.postFiles(url: url, files: files);
    print("File upload response status: ${files[0].path}");
    if (res.statusCode == 201) {
      final data =
          (res.body['data'] as List)
              .map((e) => Attachment.fromJson(e))
              .toList();
    } else {}
    emit(current.copyWith());
  }

  Future<List<File>> urlListToFileList(List<String> urls) async {
    List<File> files = [];

    for (final url in urls) {
      final file = await urlToFile(url);
      files.add(file);
    }

    return files;
  }
}
