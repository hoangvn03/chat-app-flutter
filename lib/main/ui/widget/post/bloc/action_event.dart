import 'package:chat_app/main/networks/model/comment.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/widget/post/widgets/interaction_button.dart';

abstract class ActionEvent {}

class LoadComment extends ActionEvent {
  final PostModel post;
  LoadComment({required this.post});
}

class PostCommnet extends ActionEvent {
  final String content;
  final int postId;
  PostCommnet({required this.content, required this.postId});
}

class PostCommnetReply extends ActionEvent {
  final String content;
  final int postId;
  final int commentId;
  final String userTag;
  PostCommnetReply({
    required this.content,
    required this.postId,
    required this.commentId,
    required this.userTag,
  });
}

class ActionPost extends ActionEvent {
  final InteractionType typeAction;
  final int postId;
  ActionPost({required this.typeAction, required this.postId});
}
