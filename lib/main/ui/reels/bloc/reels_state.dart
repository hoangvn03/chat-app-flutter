import 'package:chat_app/main/networks/model/post.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsSuccess extends ReelsState {
  final List<PostModel>? posts;
  final List<String>? ReelsResults;

  ReelsSuccess({
    this.posts,
    this.ReelsResults,
  });

  ReelsSuccess copyWith({
    List<PostModel>? posts,
    List<String>? ReelsResults,
  }) {
    return ReelsSuccess(
      posts: posts ?? this.posts,
      ReelsResults: ReelsResults ?? this.ReelsResults,
    );
  }
}


class ReelsFailure extends ReelsState {
  final String errorMessage;
  ReelsFailure(this.errorMessage);
}
