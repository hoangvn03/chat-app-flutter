import 'package:chat_app/main/networks/model/user.dart';

class PostModel {
   String? id;
   UserModel user;
   String? postImage;
   String? caption;
   String? typePost;
   int? likes;
   String? timeAgo;
   String? timePost;

  PostModel({
    this.id,
    required this.user,
    this.typePost,
    this.postImage,
    this.caption,
    this.likes,
    this.timeAgo,
    this.timePost
  });
}
