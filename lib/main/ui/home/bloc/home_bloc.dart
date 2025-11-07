import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_images.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SocketService socketService;
  HomeBloc(this.socketService) : super(HomeLoading()) {
    on<LoadRequest>(_loadRequest);
    on<GetNotificationCount>(_getUnreadNotiCount);
    on<UpdateStatusUsers>(_updateStatusUser);
  }
  UserModel user = UserModel(id: 999);

  Future<void> _loadRequest(LoadRequest event, Emitter<HomeState> emit) async {
    try {
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

      final List<PostModel> posts = [
        PostModel(
          id: "1",
          user: UserModel(
            id: 999,
            username: 'david',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=1",
          caption: "Cuối tuần chill 😎",
          likes: 120,
          timeAgo: "2 giờ trước",
        ),
        PostModel(
          id: "2",
          user: UserModel(
            id: 999,

            username: 'hieu_thu_2',
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
            username: 'rose',
            avatar: AppImages.imgAvatarDefault,
          ),
          postImage: "https://picsum.photos/400/400?random=4",
          caption: "Du lịch biển 🌊",
          likes: 240,
          timeAgo: "2 ngày trước",
        ),
      ];

      final reels = [
        ReelModel(user: UserModel(id: 999, username: "Hoang")),
        ReelModel(user: UserModel(id: 999, username: "Tuan Anh")),
      ];
      emit(HomeSuccess(reels: reels, posts: posts, user: user));
    } catch (e) {
      emit(HomeFailure());
    }
    return;
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

  @override
  Future<void> close() {
    socketService.socket.off('status_updated');
    socketService.socket.off('unread_notifications_count');
    return super.close();
  }
}
