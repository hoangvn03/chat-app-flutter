import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/profile_model.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileSuccess extends ProfileState {
  final UserModel user;
  final Stats? stats;
  final List<ReelModel>? reels;
  final List<PostChild>? posts;
  final List<UserModel>? suggestUsers;
  final List<UserModel>? usersContatct;
  final List<UserModel>? userFollowing;
  final int? conversationId;
  final Conversation? conversation;
  final bool hasFollow;

  ProfileSuccess({
    required this.user,
    this.stats,
    this.reels,
    this.posts,
    this.suggestUsers,
    this.userFollowing,
    this.usersContatct,
    this.conversationId,
    this.conversation,
    this.hasFollow = false
  });

  ProfileSuccess copyWith({
    UserModel? user,
    Stats? stats,
    List<ReelModel>? reels,
    List<PostChild>? posts,
    List<UserModel>? suggestUsers,
    List<UserModel>? usersContatct,
    List<UserModel>? userFollowing,
    int? conversationId,
    Conversation? conversation,
    bool? hasFollow
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      stats: stats ?? this.stats,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      suggestUsers: suggestUsers ?? this.suggestUsers,
      usersContatct: usersContatct ?? this.usersContatct,
      userFollowing: userFollowing ?? this.userFollowing,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      hasFollow: hasFollow ?? this.hasFollow,
    );
  }
}

class ProfileFailure extends ProfileState {
  String? erroMessage;
  ProfileFailure({this.erroMessage});
}
