import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/features/post/action/bloc/action_event.dart';
import 'package:chat_app/main/features/post/action/bloc/action_state.dart';
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
  UserModel user = UserModel();

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
            name: "ngoc_hoang",
            email: "ngoc@gmail.com",
            avatar: "https://picsum.photos/200/200?1",
            roleData: RoleData(id: 1, code: "USER", value: "Người dùng"),
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
            name: "linh_123",
            email: "linh@gmail.com",
            avatar: "https://picsum.photos/200/200?2",
            roleData: RoleData(id: 1, code: "USER", value: "Người dùng"),
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
            name: "phuc_dev",
            email: "phuc@gmail.com",
            avatar: "https://picsum.photos/200/200?3",
            roleData: RoleData(id: 2, code: "MOD", value: "Người kiểm duyệt"),
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
