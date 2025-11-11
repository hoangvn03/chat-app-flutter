
import 'package:chat_app/main/networks/model/comment.dart';

abstract class ActionState {}
class ActionLoading extends ActionState {}
class ActionSuccess extends ActionState {
  final List<CommentModel> comments;
  final bool isSelected;
  final dynamic data;
  ActionSuccess({required this.comments,this.isSelected = false, this.data});

  ActionSuccess copyWith({
    List<CommentModel>? comments,
    bool? isSelected,
    dynamic data
  }) {
    return ActionSuccess(
      comments: comments ?? this.comments,
      isSelected: isSelected ?? this.isSelected,
      data: data ?? this.data,
    );
  }
}

class ActionFailure extends ActionState {}
