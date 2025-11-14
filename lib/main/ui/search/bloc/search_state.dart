import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<UserModel>? users;
  final List<PostModel>? posts;
  final List<String>? searchResults;

  SearchSuccess({
    this.users,
    this.posts,
    this.searchResults,
  });

  SearchSuccess copyWith({
    List<UserModel>? users,
    List<PostModel>? posts,
    List<String>? searchResults,
  }) {
    return SearchSuccess(
      users: users ?? this.users,
      posts: posts ?? this.posts,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

class SearchFailure extends SearchState {
  final String errorMessage;
  SearchFailure(this.errorMessage);
}
