import 'dart:async';
import 'dart:io';
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
  final SocketService socketService = SocketService();
  HomeBloc() : super(HomeLoading()) {
    on<LoadRequest>(_loadRequest);
    on<GetNotificationCount>(_getUnreadNotiCount);
    on<UpdateStatusUsers>(_updateStatusUser);
    on<CreatePost>(_createPost);
    on<AddNewPost>(_addPost);
  }
  final List<PostModel> _posts = [];
  Future<void> _loadRequest(LoadRequest event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());
      var url = ApiEndPoints.LOADPOST;
      final param = {'page': '1', 'limit': '10'};
      int num = 0;
      final user = await AppStorage.getUser();
      ApiResponse res = await ApiUtil.get(url, params: param);

      if (res.statusCode == 200) {
        final test =
            (res.body['data']['posts'] as List)
                .map((e) => PostModel.fromJson(e))
                .toList();
        _posts.addAll(test);
      }
      await socketService.initSocket();
      socketService.socket.on('unread_notifications_count', (data) {
        print("Noti Gui :${data['count']}");
        num = data['count'] as int;
        add(GetNotificationCount(num));
      });
      socketService.socket.on('status_updated', (data) {
        add(UpdateStatusUsers(isInit: false, status: data['status']));
      });
      socketService.connect();
      socketService.updateUserStatus(StatusUser.online.name);
      emit(HomeSuccess(reels: [], posts: _posts, user: user, numNoti: num));
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
      final files = pathsToFiles(event.assetImage);
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
  Future<void> close() async {
    socketService.socket.off('status_updated');
    socketService.socket.off('unread_notifications_count');
    // await socketService.disconnect();
    await socketService.dispose();
    print('HomeBloc closed and socket disposed.');
    return super.close();
  }
}
