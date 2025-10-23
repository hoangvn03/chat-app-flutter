import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
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
            id: 999,

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
            id: 999,

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
          user: UserModel(
            id: 999,
            username: 'lisa',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=3",
          caption: "Coding all day 💻🔥",
          likes: 300,
          timeAgo: "1 ngày trước",
        ),
        PostModel(
          id: "4",
          user: UserModel(
            id: 999,

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
          user: UserModel(
            id: 999,
            username: 'tuan_anh',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=5",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "6",
          typePost: "reels",
          user: UserModel(
            id: 999,

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
          user: UserModel(
            id: 999,
            username: 'rosé',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=7",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "8",
          typePost: "video",
          user: UserModel(
            id: 999,
            username: 'david',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=8",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "9",
          user: UserModel(
            id: 999,
            username: 'yasuo',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=9",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "10",
          user: UserModel(
            id: 999,
            username: 'hasagi',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=10",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "11",
          user: UserModel(
            id: 999,
            username: 'anna',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=11",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
        PostModel(
          id: "12",
          user: UserModel(
            id: 999,

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
            id: 999,

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
            id: 999,

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
            id: 999,

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
        ReelModel(user: UserModel(id: 999, username: "Hoang")),
        ReelModel(user: UserModel(id: 999, username: "Tuan Anh")),
      ];
      emit(SearchSuccess(reels: reels, posts: posts));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
    return;
  }

  Future<void> _searchRequest(
    PressInputSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      var url = ApiEndPoints.USERS;
      var params = {'page': '1', 'limit': '10', 'search': event.input};
      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final data = UserResponse.fromJson(res.body['data']);
        if (state is SearchSuccess) {
          final current = state as SearchSuccess;
          emit(current.copyWith(users: data.users));
        } else {
          emit(SearchSuccess(users: data.users));
        }
      } else {
        emit(SearchFailure('${res.statusCode} Fail to load api'));
      }
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}
