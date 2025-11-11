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
          postId: 1,
          userId: 1,
          caption:
              "Buổi sáng tuyệt vời tại Hà Nội! Thật sự thư giãn. #travel #hanoi",
          location: "Bạch Thanh Trà",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-08T06:29:07.000Z"),
          updatedAt: DateTime.parse("2025-11-08T06:29:07.000Z"),
          author: UserModel(
            id: 1,
            username: "alice",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Alice",
          ),
          media: [
            Media(mediaUrl:'https://picsum.photos/400/400?random=1'),
          ]
        ),
        PostModel(
          postId: 2,
          userId: 2,
          caption: "Cà phê sáng ở Đà Lạt thật chill ☕🌿 #coffee #dalat",
          location: "Tiệm cà phê Mộc",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-07T08:45:20.000Z"),
          updatedAt: DateTime.parse("2025-11-07T08:45:20.000Z"),
          author: UserModel(
            id: 2,
            username: "bob",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Bob",
          ),
        ),
        PostModel(
          postId: 3,
          userId: 3,
          caption: "Chiều hoàng hôn bên sông thật đẹp 🌅 #sunset #relax",
          location: "Bến Bạch Đằng",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-06T17:30:00.000Z"),
          updatedAt: DateTime.parse("2025-11-06T17:30:00.000Z"),
          author: UserModel(
            id: 3,
            username: "carol",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Carol",
          ),
        ),
        PostModel(
          postId: 4,
          userId: 4,
          caption: "Làm việc chăm chỉ hôm nay để mai thành công 💪 #workhard",
          location: "Hồ Chí Minh",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-05T09:00:00.000Z"),
          updatedAt: DateTime.parse("2025-11-05T09:00:00.000Z"),
          author: UserModel(
            id: 4,
            username: "david",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=David",
          ),
        ),
        PostModel(
          postId: 5,
          userId: 5,
          caption: "Một ngày nắng đẹp để đi dạo 🌞 #weekend #happy",
          location: "Cầu Thủ Thiêm 2",
          isArchived: false,
          createdAt: DateTime.parse("2025-11-04T15:15:00.000Z"),
          updatedAt: DateTime.parse("2025-11-04T15:15:00.000Z"),
          author: UserModel(
            id: 5,
            username: "emma",
            avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Emma",
          ),
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
