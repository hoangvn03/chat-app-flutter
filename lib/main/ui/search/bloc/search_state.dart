import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  List<UserModel>? users;
  List<ReelModel>? reels;
  List<PostModel>? posts;
  List<String>? searchResults;
  SearchSuccess({this.users, this.reels, this.posts, this.searchResults});
}

class SearchFailure extends SearchState {}

