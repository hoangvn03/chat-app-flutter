import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/search/bloc/search_event.dart';
import 'package:chat_app/main/ui/search/bloc/search_state.dart';
import 'package:chat_app/res/app_images.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchLoading()) {
    on<LoadRequest>(_loadRequest);
    on<PressInputSearch>(_searchRequest);
  }
  Future<void> _loadRequest(
    LoadRequest event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final List<PostModel> posts = [
        PostModel(
          id: "1",
          user: UserModel(
            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=1",
          caption: "Cuối tuần chill 😎",
          likes: 120,
          typePost: "reels",
          timeAgo: "2 giờ trước",
        ),
        PostModel(
          id: "2",
          user: UserModel(
            username: 'linh_nguyen',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=2",
          caption: "Cà phê sáng ☕",
          likes: 89,
          timeAgo: "5 giờ trước",
        ),
        PostModel(
          id: "3",
          user: UserModel(username: 'lisa', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=3",
          caption: "Coding all day 💻🔥",
          likes: 300,
          timeAgo: "1 ngày trước",
        ),
        PostModel(
          id: "4",
          user: UserModel(
            username: 'thanh_nguyen',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "5",
          user: UserModel(username: 'tuan_anh', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=5",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "6",
          typePost: "reels",
          user: UserModel(
            username: 'minh_hieu',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=6",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "7",
          typePost: "reels",
          user: UserModel(username: 'rosé', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=7",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "8",
          typePost: "video",
          user: UserModel(username: 'david', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=8",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "9",
          user: UserModel(username: 'yasuo', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=9",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "10",
          user: UserModel(username: 'hasagi', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=10",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "11",
          user: UserModel(username: 'anna', avatar: AppImages.imgAvatarDefault),
          postImage: "https://picsum.photos/400/400?random=11",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "12",
          user: UserModel(
            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "13",
          user: UserModel(
            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "14",
          user: UserModel(
            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=14",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "15",
          user: UserModel(
            username: 'hieu_pham',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=15",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
      ];

      final reels = [
        ReelModel(user: UserModel(username: "Hoang")),
        ReelModel(user: UserModel(username: "Tuan Anh")),
      ];
      emit(SearchSuccess(reels: reels, posts: posts));
    } catch (e) {
      emit(SearchFailure());
    }
    return;
  }

  Future<void> _searchRequest(
    PressInputSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final List<UserModel> users = [
        UserModel(username: 'hieu_pham', avatar: AppImages.imgAvatarDefault),
        UserModel(username: 'tuan_anh', avatar: AppImages.imgAvatarDefault),
        UserModel(username: 'nguyen_nguyen', avatar: AppImages.imgAvatarDefault),
        UserModel(username: 'ngoc_hoang', avatar: AppImages.imgAvatarDefault),
        UserModel(username: 'minh_hieu', avatar: AppImages.imgAvatarDefault),
      ];
      emit(SearchSuccess(users: users));
    } catch (e) {
      emit(SearchFailure());
    }
  }
}
