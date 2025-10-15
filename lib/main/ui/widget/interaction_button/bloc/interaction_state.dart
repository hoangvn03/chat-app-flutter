class InteractionState {
  final bool isLiked;
  final bool isSaved;
  final bool isFollowed;
  final bool isReadMore;

  InteractionState({
    this.isLiked = false,
    this.isSaved = false,
    this.isFollowed = false,
    this.isReadMore = false,
  });

  InteractionState copyWith({
    bool? isLiked,
    bool? isSaved,
    bool? isFollowed,
    bool? isReadMore,
  }) {
    return InteractionState(
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isFollowed: isFollowed ?? this.isFollowed,
      isReadMore: isReadMore ?? this.isReadMore,
    );
  }
}