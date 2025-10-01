
import 'package:chat_app/main/networks/model/comment.dart';

abstract class ActionState {}
class ActionLoading extends ActionState {}
class ActionSuccess extends ActionState {
  List<CommentItemModel> comments;
  ActionSuccess(this.comments);
}
class ActionFailure extends ActionState {}
