import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ChatState {}
class ChatLoading extends ChatState {}
class ChatSuccess extends ChatState {
  UserModel? user;
  List<ReelModel>? reels;
  List<PostModel>? posts;
  ChatSuccess({this.user,this.reels,this.posts});
}
class ChatFailure extends ChatState {}
