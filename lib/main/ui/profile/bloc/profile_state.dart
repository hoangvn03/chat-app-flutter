import 'package:chat_app/main/networks/model/contact_user.dart';
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
  final List<UserModel>? friendContact;
  final List<ContactUser>? userFollowing;
  final int? conversationId;
  final Conversation? conversation;
  final bool hasFollow;
  final int? numFollowing;

  ProfileSuccess({
    required this.user,
    this.stats,
    this.reels,
    this.posts,
    this.suggestUsers,
    this.userFollowing,
    this.friendContact,
    this.usersContatct,
    this.conversationId,
    this.conversation,
    this.numFollowing,
    this.hasFollow = false
  });

  ProfileSuccess copyWith({
    UserModel? user,
    Stats? stats,
    List<ReelModel>? reels,
    List<PostChild>? posts,
    List<UserModel>? suggestUsers,
    List<UserModel>? friendContact,
    List<UserModel>? usersContatct,
    List<ContactUser>? userFollowing,
    int? conversationId,
    Conversation? conversation,
    int? numFollowing,
    bool? hasFollow
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      stats: stats ?? this.stats,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      suggestUsers: suggestUsers ?? this.suggestUsers,
      usersContatct: usersContatct ?? this.usersContatct,
      friendContact: friendContact ?? this.friendContact,
      userFollowing: userFollowing ?? this.userFollowing,
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      numFollowing: numFollowing ?? this.numFollowing,
      hasFollow: hasFollow ?? this.hasFollow,
    );
  }
}

class ProfileFailure extends ProfileState {
  String? erroMessage;
  ProfileFailure({this.erroMessage});
}
