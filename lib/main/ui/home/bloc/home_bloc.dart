import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SocketService socketService;
  HomeBloc(this.socketService) : super(HomeLoading()) {
    on<LoadRequest>(_loadRequest);
    on<GetNotificationCount>(_getUnreadNotiCount);
    on<UpdateStatusUsers>(_updateStatusUser);
    on<CreatePost>(_createPost);
    on<AddNewPost>(_addPost);
  }
  UserModel user = UserModel(id: 999);
  final List<PostModel> _posts = [];
  Future<void> _loadRequest(LoadRequest event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      var url = ApiEndPoints.LOADPOST;
      final param = {'page': '1', 'limit': '10'};
      socketService.updateUserStatus(StatusUser.online.name);
      socketService.socket.on('unread_notifications_count', (data) {
        print("Noti Gui :$data['count]");
        final num = data['count'] as int;
        add(GetNotificationCount(num));
      });
      socketService.socket.on('status_updated', (data) {
        add(UpdateStatusUsers(isInit: false, status: data['status']));
      });
      final user = await AppStorage.getUser();
      // final List<PostModel> test = [
      //   PostModel(
      //     postId: 1,
      //     userId: 1,
      //     caption:
      //         "Buổi sáng tuyệt vời tại Hà Nội! Thật sự thư giãn. #travel #hanoi",
      //     location: "Bạch Thanh Trà",
      //     isArchived: false,
      //     createdAt: DateTime.parse("2025-11-08T06:29:07.000Z"),
      //     updatedAt: DateTime.parse("2025-11-08T06:29:07.000Z"),
      //     author: UserModel(
      //       id: 1,
      //       username: "alice",
      //       avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Alice",
      //     ),
      //   ),
      //   PostModel(
      //     postId: 2,
      //     userId: 2,
      //     caption: "Cà phê sáng ở Đà Lạt thật chill ☕🌿 #coffee #dalat",
      //     location: "Tiệm cà phê Mộc",
      //     isArchived: false,
      //     createdAt: DateTime.parse("2025-11-07T08:45:20.000Z"),
      //     updatedAt: DateTime.parse("2025-11-07T08:45:20.000Z"),
      //     author: UserModel(
      //       id: 2,
      //       username: "bob",
      //       avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Bob",
      //     ),
      //   ),
      //   PostModel(
      //     postId: 3,
      //     userId: 3,
      //     caption: "Chiều hoàng hôn bên sông thật đẹp 🌅 #sunset #relax",
      //     location: "Bến Bạch Đằng",
      //     isArchived: false,
      //     createdAt: DateTime.parse("2025-11-06T17:30:00.000Z"),
      //     updatedAt: DateTime.parse("2025-11-06T17:30:00.000Z"),
      //     author: UserModel(
      //       id: 3,
      //       username: "carol",
      //       avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Carol",
      //     ),
      //   ),
      //   PostModel(
      //     postId: 4,
      //     userId: 4,
      //     caption: "Làm việc chăm chỉ hôm nay để mai thành công 💪 #workhard",
      //     location: "Hồ Chí Minh",
      //     isArchived: false,
      //     createdAt: DateTime.parse("2025-11-05T09:00:00.000Z"),
      //     updatedAt: DateTime.parse("2025-11-05T09:00:00.000Z"),
      //     author: UserModel(
      //       id: 4,
      //       username: "david",
      //       avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=David",
      //     ),
      //   ),
      //   PostModel(
      //     postId: 5,
      //     userId: 5,
      //     caption: "Một ngày nắng đẹp để đi dạo 🌞 #weekend #happy",
      //     location: "Cầu Thủ Thiêm 2",
      //     isArchived: false,
      //     createdAt: DateTime.parse("2025-11-04T15:15:00.000Z"),
      //     updatedAt: DateTime.parse("2025-11-04T15:15:00.000Z"),
      //     author: UserModel(
      //       id: 5,
      //       username: "emma",
      //       avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=Emma",
      //     ),
      //   ),
      // ];

      ApiResponse res = await ApiUtil.get(url, params: param);
      if (res.statusCode == 200) {
        final test =
            (res.body['data']['posts'] as List)
                .map((e) => PostModel.fromJson(e))
                .toList();
        _posts.addAll(test);
      }

      final reels = [
        ReelModel(user: UserModel(id: 999, username: "Hoang")),
        ReelModel(user: UserModel(id: 999, username: "Tuan Anh")),
      ];
      emit(HomeSuccess(reels: reels, posts: _posts, user: user));
    } catch (e) {
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _getUnreadNotiCount(
    GetNotificationCount event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeSuccess) return;
    final currentState = state as HomeSuccess;

    try {
      emit(currentState.copyWith(numNoti: event.num));
    } catch (e) {
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _updateStatusUser(
    UpdateStatusUsers event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeSuccess) return;
    final currentState = state as HomeSuccess;
    try {
      if (event.isInit) {
        socketService.updateUserStatus(StatusUser.online.name);
      } else {
        emit(currentState.copyWith(statusUser: event.status));
      }
    } catch (e) {
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _createPost(CreatePost event, Emitter<HomeState> emit) async {
    if (state is! HomeSuccess) return;
    final currentState = state as HomeSuccess;
    var url = ApiEndPoints.LOADPOST;
    var url2 = ApiEndPoints.UPLOADPOST;
    try {
      print('Step 1: Create Post');
      final body = {"caption": event.caption, "location": event.location};
      emit(currentState.copyWith(isLoading: true));
      final files = await uint8ListListToFileList(event.assetImage,"edited_image");
      ApiResponse res = await ApiUtil.post(url: url, data: body);
      if (res.statusCode == 201) {
        final post = PostModel.fromJson(res.body);
        ApiResponse loadImagePost = await ApiUtil.postFiles(
          url: '$url2/${post.postId}',
          files: files,
          key: 'media',
        );
        if (loadImagePost.statusCode == 201) {
          ApiResponse res = await ApiUtil.get('$url/${post.postId}');
          if (res.statusCode == 200) {
            print('Post: ${currentState.posts}');
            final newPost = PostModel.fromJson(res.body);
            final updatedPosts = <PostModel>[
              newPost,
              ...currentState.posts ?? [],
            ];
            print('Post 2: ${updatedPosts}');

            emit(currentState.copyWith(posts: updatedPosts, isLoading: false));
          }
        }
      }
    } catch (e) {
      print('Step Error: Create Post');

      print(e.toString());
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _addPost(AddNewPost event, Emitter<HomeState> emit) async {
    final currentState =
        state is HomeSuccess ? state as HomeSuccess : HomeSuccess(posts: []);
    try {
      print('Step 2: Add Post');
      final updatedPosts = <PostModel>[event.post, ...currentState.posts ?? []];
      emit(currentState.copyWith(posts: updatedPosts, isLoading: false));
    } catch (e) {
      print('Step Error: Create Post');
      print(e.toString());
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    socketService.socket.off('status_updated');
    socketService.socket.off('unread_notifications_count');
    return super.close();
  }
}
