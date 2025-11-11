import 'package:chat_app/main/networks/model/comment.dart';
import 'package:chat_app/main/networks/model/user.dart';

class PostModel {
  int? postId;
  int? userId;
  String? caption;
  String? location;
  bool? isArchived;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likesCount;
  int? commentsCount;
  int? saveCount;
  bool? isSaved;
  bool? isLiked;
  UserModel? author;
  List<Media>? media;
  List<CommentModel>? comments;

  PostModel({
    this.postId,
    this.userId,
    this.caption,
    this.location,
    this.isArchived,
    this.createdAt,
    this.updatedAt,
    this.likesCount,
    this.commentsCount,
    this.saveCount,
    this.isSaved,
    this.isLiked,
    this.author,
    this.media,
    this.comments,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    caption = json['caption'];
    location = json['location'];
    isArchived = json['is_archived'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    likesCount = json['likeCount'];
    commentsCount = json['commentCount'];
    saveCount = json['saveCount'];
    isSaved = json['isSaved'];
    isLiked = json['isLiked'];
    author = json['author'] != null ? UserModel.fromJson(json['author']) : null;
    if (json['media'] != null) {
      media = <Media>[];
      for (var v in json['media']) {
        media!.add(Media.fromJson(v));
      }
    }
    if (json['comments'] != null) {
      comments = <CommentModel>[];
      for (var v in json['comments']) {
        comments!.add(CommentModel.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['post_id'] = postId;
    data['user_id'] = userId;
    data['caption'] = caption;
    data['location'] = location;
    data['is_archived'] = isArchived;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    data['saveCount'] = saveCount;
    data['isSaved'] = isSaved;
    data['isLiked'] = isSaved;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  int? userId;
  String? username;
  String? avatarUrl;

  Author({this.userId, this.username, this.avatarUrl});

  Author.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'username': username, 'avatar_url': avatarUrl};
  }
}

class Media {
  int? mediaId;
  String? mediaUrl;
  String? mediaType;
  int? orderIndex;

  Media({this.mediaId, this.mediaUrl, this.mediaType, this.orderIndex});

  Media.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    orderIndex = json['order_index'];
  }

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
      'media_url': mediaUrl,
      'media_type': mediaType,
      'order_index': orderIndex,
    };
  }
}
