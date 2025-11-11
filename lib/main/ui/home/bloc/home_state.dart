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
  final PostModel? post;
  final int? numNoti;
  final String? statusUser;
  final bool isLoading;
  HomeSuccess({
    this.user,
    this.reels,
    this.posts,
    this.post,
    this.numNoti,
    this.statusUser,
    this.isLoading = false,
  });
  HomeSuccess copyWith({
    UserModel? user,
    List<ReelModel>? reels,
    List<PostModel>? posts,
    PostModel? post,
    int? numNoti,
    String? statusUser,
    bool? isLoading,
  }) {
    return HomeSuccess(
      user: user ?? this.user,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      post: post ?? this.post,
      numNoti: numNoti ?? this.numNoti,
      statusUser: statusUser ?? this.statusUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  @override
  List<Object?> get props => [user, reels, posts,post, numNoti,isLoading];
}

class HomeFailure extends HomeState {
  final String? errorMessage;
  HomeFailure({this.errorMessage});
}
