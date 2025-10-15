import 'package:chat_app/main/ui/widget/interaction_button/bloc/interaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InteractionCubit extends Cubit<InteractionState> {
  InteractionCubit() : super(InteractionState());
    void toggleLike() {
    emit(state.copyWith(isLiked: !state.isLiked));
  }

  void toggleSave() {
    emit(state.copyWith(isSaved: !state.isSaved));
  }

  void toggleFollow() {
    emit(state.copyWith(isFollowed: !state.isFollowed));
  }

  void toggleReadMore() {
    emit(state.copyWith(isReadMore: !state.isReadMore));
  }
}
