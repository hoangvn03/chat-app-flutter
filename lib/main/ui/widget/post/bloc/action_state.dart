import 'package:chat_app/main/networks/model/comment.dart';

abstract class ActionState {}

class ActionLoading extends ActionState {}

class ActionSuccess extends ActionState {
  final List<CommentModel> comments;
  final bool isSelected;
  final int? data;//likeCount
  final int? cmtCount;
  final int? shareCount;
  ActionSuccess({
    required this.comments,
    this.isSelected = false,
    this.data,
    this.cmtCount,
    this.shareCount,
  });

  ActionSuccess copyWith({
    List<CommentModel>? comments,
    bool? isSelected,
    dynamic data,
    int? cmtCount,
    int? shareCount
  }) {
    return ActionSuccess(
      comments: comments ?? this.comments,
      isSelected: isSelected ?? this.isSelected,
      data: data ?? this.data,
      shareCount: shareCount ?? this.shareCount,
      cmtCount: cmtCount ?? this.cmtCount,
    );
  }
}

class ActionFailure extends ActionState {}
