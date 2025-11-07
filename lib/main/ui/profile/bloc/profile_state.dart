import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileSuccess extends ProfileState {
  final UserModel user;
  final List<ReelModel>? reels;
  final List<PostModel>? posts;
  final int? conversationId;
  final Conversation? conversation;

  ProfileSuccess({
    required this.user,
    this.reels,
    this.posts,
    this.conversationId,
    this.conversation,
  });

  ProfileSuccess copyWith({
    UserModel? user,
    List<ReelModel>? reels,
    List<PostModel>? posts,
    int? conversationId,
    Conversation? conversation,
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
    );
  }
}

class ProfileFailure extends ProfileState {
  String? erroMessage;
  ProfileFailure({this.erroMessage});
}
