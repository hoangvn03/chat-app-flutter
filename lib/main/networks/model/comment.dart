import 'package:chat_app/main/networks/model/user.dart';

class CommentItemModel {
  final int id;
  final int postId;
  final UserModel user;
  final bool isAuthor;
  final int? parentId;       
  final DateTime createdAt;
  final String text;
  final String? tagUserContact;
  final int likesCount;
  final bool isLikedByMe;

  CommentItemModel({
    required this.id,
    required this.postId,
    required this.user,
    required this.isAuthor,
    this.parentId,
    required this.createdAt,
    required this.text,
    this.tagUserContact,
    this.likesCount = 0,
    this.isLikedByMe = false,
  });
}
