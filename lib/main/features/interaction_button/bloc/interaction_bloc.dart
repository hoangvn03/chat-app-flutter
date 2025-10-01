import 'package:chat_app/main/features/interaction_button/bloc/interaction_event.dart';
import 'package:chat_app/main/features/interaction_button/bloc/interaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InteractionBloc extends Bloc<InteractionEvent, InteractionState> {
  InteractionBloc() : super(InteractionState()) {
    on<LikePost>((event, emit) {
      emit(state.copyWith(isLiked: !state.isLiked));
    });

    on<SavePost>((event, emit) {
      emit(state.copyWith(isSaved: !state.isSaved));
    });

    on<FollowUser>((event, emit) {
      emit(state.copyWith(isFollowed: !state.isFollowed));
    });
    on<ReadMore>((event, emit) {
      emit(state.copyWith(isReadMore: !state.isReadMore));
    });
  }
}
