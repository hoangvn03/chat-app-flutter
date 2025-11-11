import 'package:chat_app/main/networks/model/user.dart';

class CommentModel {
  int? commentId;
  int? userId;
  int? postId;
  int? parentCommentId;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? commenter;
  List<CommentModel>? children;

  CommentModel({
    this.commentId,
    this.userId,
    this.postId,
    this.parentCommentId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.commenter,
    this.children,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['comment_id'],
      userId: json['user_id'],
      postId: json['post_id'],
      parentCommentId: json['parent_comment_id'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      commenter: json['commenter'] != null
          ? UserModel.fromJson(json['commenter'])
          : null,
      children: json['children'] != null
          ? List<CommentModel>.from(
              (json['children'] as List).map(
                (child) => CommentModel.fromJson(child),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'user_id': userId,
      'post_id': postId,
      'parent_comment_id': parentCommentId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'commenter': commenter?.toJson(),
      'children': children?.map((v) => v.toJson()).toList(),
    };
  }

  // ✅ Thêm hàm copyWith để dễ cập nhật field
  CommentModel copyWith({
    int? commentId,
    int? userId,
    int? postId,
    int? parentCommentId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? commenter,
    List<CommentModel>? children,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      commenter: commenter ?? this.commenter,
      children: children ?? this.children,
    );
  }
}
