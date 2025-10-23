import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/ui/widget/post/action/bloc/action_event.dart';
import 'package:chat_app/main/ui/widget/post/action/bloc/action_state.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/comment.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:http/http.dart' as ApiUtil;

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  ActionBloc() : super(ActionLoading()) {
    on<LoadRequest>(_loadRequest);
  }
  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<ActionState> emit,
  ) async {
    try {
      final comments = <CommentItemModel>[
        CommentItemModel(
          id: 1,
          postId: 101,
          user: UserModel(
            id: 1,
            username: "ngoc_hoang",
            email: "ngoc@gmail.com",
            avatar: "https://picsum.photos/200/200?1",
          ),
          isAuthor: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
          text: "Buổi chiều hôm nay chill thật sự 😍",
          likesCount: 12,
        ),
        CommentItemModel(
          id: 2,
          postId: 101,
          user: UserModel(
            id: 2,
            username: "linh_123",
            email: "linh@gmail.com",
            avatar: "https://picsum.photos/200/200?2",
          ),
          isAuthor: false,
          parentId: 1, // 👈 trả lời comment id=1
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          text: "Đúng rồi, ánh sáng đẹp quá 🥰",
          tagUserContact: "ngoc_hoang",
          likesCount: 5,
          isLikedByMe: true,
        ),
        CommentItemModel(
          id: 3,
          postId: 101,
          user: UserModel(
            id: 3,
            username: "phuc_dev",
            email: "phuc@gmail.com",
            avatar: "https://picsum.photos/200/200?3",
          ),
          isAuthor: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
          text: "Ai chụp thế, góc đẹp quá 👍",
          likesCount: 2,
        ),
      ];

      emit(ActionSuccess(comments));
    } catch (e) {
      emit(ActionFailure());
    }
    return;
  }
}
