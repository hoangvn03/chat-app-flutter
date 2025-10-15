import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileSuccess extends ProfileState {
  UserModel? user;
  List<ReelModel>? reels;
  List<PostModel>? posts;
  ProfileSuccess({this.user,this.reels,this.posts});
}
class ProfileFailure extends ProfileState {
  String? erroMessage;
  ProfileFailure({this.erroMessage});
}
