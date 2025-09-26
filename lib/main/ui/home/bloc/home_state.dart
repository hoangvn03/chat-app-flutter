import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {
  UserModel? user;
  List<ReelModel>? reels;
  List<PostModel>? posts;
  HomeSuccess({this.user,this.reels,this.posts});
}
class HomeFailure extends HomeState {}
