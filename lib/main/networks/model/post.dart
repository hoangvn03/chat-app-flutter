class PostModel {
   String? id;
   String? username;
   String? userAvatar;
   String? postImage;
   String? caption;
   int? likes;
   String? timeAgo;
   String? timePost;

  PostModel({
    this.id,
    this.username,
    this.userAvatar,
    this.postImage,
    this.caption,
    this.likes,
    this.timeAgo,
    this.timePost
  });
}
