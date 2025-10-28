import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class SettingState {}
class SettingLoading extends SettingState {}
class SettingSuccess extends SettingState {
  UserModel? user;
  List<ReelModel>? reels;
  List<PostModel>? posts;
  SettingSuccess({this.user,this.reels,this.posts});
}
class SettingFailure extends SettingState {
  String? erroMessage;
  SettingFailure({this.erroMessage});
}
