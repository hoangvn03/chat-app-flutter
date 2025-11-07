import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {
  final UserModel? user;
  final List<ReelModel>? reels;
  final List<PostModel>? posts;
  final int? numNoti;
  final String? statusUser;
  HomeSuccess({
    this.user,
    this.reels,
    this.posts,
    this.numNoti,
    this.statusUser,
  });
  HomeSuccess copyWith({
    UserModel? user,
    List<ReelModel>? reels,
    List<PostModel>? posts,
    int? numNoti,
    String? statusUser,
  }) {
    return HomeSuccess(
      user: user ?? this.user,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      numNoti: numNoti ?? this.numNoti,
      statusUser: statusUser ?? this.statusUser,
    );
  }
  @override
  List<Object?> get props => [user, reels, posts, numNoti];
}

class HomeFailure extends HomeState {
  final String? errorMessage;
  HomeFailure({this.errorMessage});
}
