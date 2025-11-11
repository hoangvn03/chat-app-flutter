class InteractionState {
  final bool isLiked;
  final bool isSaved;
  final bool isFollowed;
  final bool isReadMore;
  final int? id;
  final int? count;
  InteractionState({
    this.isLiked = false,
    this.isSaved = false,
    this.isFollowed = false,
    this.isReadMore = false,
    this.id,
    this.count,
  });

  InteractionState copyWith({
    bool? isLiked,
    bool? isSaved,
    bool? isFollowed,
    bool? isReadMore,
    int? id,
    int? count
  }) {
    return InteractionState(
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isFollowed: isFollowed ?? this.isFollowed,
      isReadMore: isReadMore ?? this.isReadMore,
      id: id ?? this.id,
      count: count ?? this.count,

    );
  }
}