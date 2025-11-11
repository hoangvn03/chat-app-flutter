import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/ui/widget/post/widgets/action/bloc/action_event.dart';
import 'package:chat_app/main/ui/widget/post/widgets/action/bloc/action_state.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/comment.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/res/app_images.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  ActionBloc() : super(ActionLoading()) {
    on<LoadComment>(_loadRequest);
    on<PostCommnet>(_postComment);
    on<PostCommnetReply>(_postCommentReply);
    on<ActionPost>(_actionPost);
  }

  Future<void> _loadRequest(
    LoadComment event,
    Emitter<ActionState> emit,
  ) async {
    try {
      emit(ActionSuccess(comments: event.listComments));
    } catch (e) {
      emit(ActionFailure());
    }
    return;
  }

  Future<void> _postComment(
    PostCommnet event,
    Emitter<ActionState> emit,
  ) async {
    if (state is! ActionSuccess) return;
    final currentState = state as ActionSuccess;
    try {
      final url = ApiEndPoints.LOADPOST;
      final params = {"content": event.content};
      ApiResponse res = await ApiUtil.post(
        url: '$url/${event.postId}/comment',
        data: params,
      );
      if (res.statusCode == 201) {
        final newComment = CommentModel.fromJson(res.body);
        final updatedComments = <CommentModel>[
          ...currentState.comments, // các comment cũ giữ nguyên thứ tự
          newComment, // comment mới thêm vào cuối
        ];
        emit(currentState.copyWith(comments: updatedComments));

        emit(currentState.copyWith(comments: updatedComments));
        // event.controller
        //     ?.clear(); // nếu bạn truyền TextEditingController qua event
      }
    } catch (e) {
      print(e.toString());
      emit(ActionFailure());
    }
  }

  Future<void> _postCommentReply(
    PostCommnetReply event,
    Emitter<ActionState> emit,
  ) async {
    if (state is! ActionSuccess) return;
    final currentState = state as ActionSuccess;
    try {
      final url = ApiEndPoints.LOADPOST;
      final params = {
        "content": event.content,
        "parent_comment_id": event.commentId,
      };
      ApiResponse res = await ApiUtil.post(
        url: '$url/${event.postId}/comment',
        data: params,
      );
      if (res.statusCode == 201) {
        final newComment = CommentModel.fromJson(res.body);
        final updatedComments = _addReplyRecursive(
          currentState.comments,
          event.commentId,
          newComment,
        );
        emit(currentState.copyWith(comments: updatedComments));
        // event.controller
        //     ?.clear(); // nếu bạn truyền TextEditingController qua event
      }
    } catch (e) {
      print(e.toString());
      emit(ActionFailure());
    }
  }

  Future<void> _actionPost(ActionPost event, Emitter<ActionState> emit) async {
    try {
      final url = '${ApiEndPoints.LOADPOST}/${event.postId}/like';
      ApiResponse res = await ApiUtil.post(url: url);
      if (res.statusCode == 200) {
        if (state is ActionSuccess) {
          final currentState = state as ActionSuccess;
          emit(
            currentState.copyWith(
              isSelected: res.body['liked'],
              data: res.body['likeCount'] as int,
            ),
          );
        } else {
          emit(
            ActionSuccess(
              isSelected: res.body['liked'],
              data: res.body['likeCount'] as int,
              comments: [],
            ),
          );
        }
      }
      // Handle other status codes if needed
    } catch (e) {
      print(e.toString());
      emit(ActionFailure());
    }
  }

  List<CommentModel> _addReplyRecursive(
    List<CommentModel> comments,
    int parentId,
    CommentModel reply,
  ) {
    return comments.map((cmt) {
      if (cmt.commentId == parentId) {
        return cmt.copyWith(children: [...?cmt.children, reply]);
      } else if ((cmt.children ?? []).isNotEmpty) {
        return cmt.copyWith(
          children: _addReplyRecursive(cmt.children!, parentId, reply),
        );
      } else {
        return cmt;
      }
    }).toList();
  }
}
