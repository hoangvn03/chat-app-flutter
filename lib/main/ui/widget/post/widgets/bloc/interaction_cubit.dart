import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/ui/widget/post/widgets/bloc/interaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InteractionCubit extends Cubit<InteractionState> {
  InteractionCubit() : super(InteractionState());
  Future<void> toggleLike1(int id) async {
    final url = '${ApiEndPoints.LOADPOST}/${id}/like';
    ApiResponse res = await ApiUtil.post(url: url);
    if (res.statusCode == 200) {
      emit(state.copyWith(isLiked: res.body['liked'],count: res.body['likeCount']));
    }
  }

  void toggleSave() {
    emit(state.copyWith(isSaved: !state.isSaved));
  }
  void toggleLike() {
    emit(state.copyWith(isLiked: !state.isLiked));
  }

  void toggleFollow() {
    emit(state.copyWith(isFollowed: !state.isFollowed));
  }

  Future<void> toggleFollow1(int id) async {
    final url = '${ApiEndPoints.PROFILE}/contacts/${id}';
    ApiResponse res = await ApiUtil.post(url: url);
    if (res.statusCode == 200) {
      emit(state.copyWith(isFollowed: res.body['liked'],count: res.body['likeCount']));
    }
  }

  void toggleReadMore() {
    emit(state.copyWith(isReadMore: !state.isReadMore));
  }
}
