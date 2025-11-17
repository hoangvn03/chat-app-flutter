import 'package:chat_app/main/main_page.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/auth/auth_page.dart';
import 'package:chat_app/main/ui/conversations/conversations_page.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/create_chat_page.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/message/chat_room.dart';
import 'package:chat_app/main/ui/conversations/screens/message/edit_infomation_group.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/home_page.dart';
import 'package:chat_app/main/ui/home/widgets/create_post_page.dart';
import 'package:chat_app/main/ui/home/widgets/edit_post_media_page.dart';
import 'package:chat_app/main/ui/home/widgets/upload_post_page.dart';
import 'package:chat_app/main/ui/notification/notification_page.dart';
import 'package:chat_app/main/ui/personal/personal_page.dart';
import 'package:chat_app/main/ui/post/post_page.dart';
import 'package:chat_app/main/ui/profile/widgets/edit_profile_page.dart';
import 'package:chat_app/main/ui/profile/widgets/profile_list_user.dart';
import 'package:chat_app/main/ui/profile/profile_page.dart';
import 'package:chat_app/main/ui/profile/widgets/settings/setting_page.dart';
import 'package:chat_app/main/ui/reels/widgets/camera/camera_page.dart';
import 'package:chat_app/main/ui/reels/widgets/create_storys/create_reels_page.dart';
import 'package:chat_app/main/ui/reels/widgets/create_storys/widgets/edit_element_media.dart';
import 'package:chat_app/main/ui/reels/story/list_story/list_reels_page.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/media_picked_page.dart';
import 'package:chat_app/main/ui/reels/reels_page.dart';
import 'package:chat_app/main/ui/search/search_page.dart';
import 'package:chat_app/main/ui/search/search_result_page.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

class AppGoRouter {
  static GoRouter get router => _goRouter;
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomePage = GlobalKey<NavigatorState>(
    debugLabel: 'home',
  );
  static final _shellNavigatorSearchPage = GlobalKey<NavigatorState>(
    debugLabel: 'search',
  );
  static final _shellNavigatorPostPage = GlobalKey<NavigatorState>(
    debugLabel: 'post',
  );
  static final _shellNavigatorReelsPage = GlobalKey<NavigatorState>(
    debugLabel: 'reels',
  );
  static final _shellNavigatorPersonalPage = GlobalKey<NavigatorState>(
    debugLabel: 'personal',
  );

  static final GoRouter _goRouter = GoRouter(
    initialLocation: AppPath.loginPage,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final isLoggedIn = await AppStorage.getIsLogin();
      final isLoggingIn = state.matchedLocation == AppPath.loginPage;

      if (isLoggedIn && isLoggingIn) {
        return AppPath.homePage;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        name: PathName.loginPage,
        path: AppPath.loginPage,
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        name: PathName.profilePage,
        path: AppPath.profilePage,
        builder: (context, state) {
          final data = state.extra as UserModel;
          return ProfilePage(user: data);
        },
      ),

      GoRoute(
        name: PathName.editProfilePage,
        path: AppPath.editProfilePage,
        builder: (context, state) {
          final data = state.extra as UserModel;
          return EditProfilePage(user: data);
        },
      ),

      GoRoute(
        name: PathName.chatPage,
        path: AppPath.chatPage,
        routes: [
          GoRoute(
            name: PathName.createChatGroupPage,
            path: AppPath.createChatGroupPage,
            pageBuilder: (context, state) {
              final createChatBloc = state.extra as CreateChatBloc;
              return slidePage(
                BlocProvider.value(
                  value: createChatBloc,
                  child: CreateChatPage(),
                ),
              );
            },
          ),
          GoRoute(
            name: PathName.chatRoomPage,
            path: AppPath.chatRoomPage,
            routes: [
              GoRoute(
                name: PathName.editInfomationGroupPage,
                path: AppPath.editInfomationGroupPage,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  return slidePage(
                    MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: extra['chatBloc']),
                        BlocProvider.value(value: extra['audioBloc']),
                        BlocProvider.value(value: extra['mediaBloc']),
                      ],
                      child: EditInfomationGroup(
                        conversation: extra['conversation'],
                      ),
                    ),
                  );
                },
              ),
            ],
            pageBuilder: (context, state) {
              final data = state.extra as Conversation;
              return slidePage(ChatRoom(conversation: data));
            },
          ),
        ],
        builder: (context, state) {
          final currentUser = state.extra as UserModel;
          return ChatPage(currentUser: currentUser);
        },
      ),

      GoRoute(
        name: PathName.profileListFollowerPage,
        path: AppPath.profileListFollowerPage,
        builder: (context, state) {
          final extra = state.extra as List;
          final currentUser = extra[0] as UserModel;
          final index = extra[1] as int;
          return ProfileListFollowerPage(user: currentUser, index: index);
        },
      ),
      GoRoute(
        name: PathName.createPostPage,
        path: AppPath.createPostPage,
        routes: [
          GoRoute(
            name: PathName.imageEditorScreen,
            path: AppPath.imageEditorScreen,
            routes: [
              GoRoute(
                name: PathName.uploadPostPage,
                path: AppPath.uploadPostPage,
                builder: (context, state) {
                  final data = state.extra as List<dynamic>;
                  final homeBloc = data[1] as HomeBloc;
                  return BlocProvider.value(
                    value: homeBloc,
                    child: UploadPostPage(assetImage: data[0]),
                  );
                },
              ),
            ],
            builder: (context, state) {
              final data = state.extra as List<dynamic>;
              final homeBloc = data[1] as HomeBloc;
              return BlocProvider.value(
                value: homeBloc,
                child: ImageEditorScreen(assetImage: data[0]),
              );
            },
          ),
        ],
        builder: (context, state) {
          return CreatePostPage();
        },
      ),
      GoRoute(
        name: PathName.createReelsPage,
        path: AppPath.createReelsPage,
        routes: [
          GoRoute(
            name: PathName.editElementMedia,
            path: AppPath.editElementMedia,
            builder: (context, state) {
              return EditElementMedia();
            },
          ),
        ],
        builder: (context, state) {
          final listMediaPath = state.extra as List<dynamic>;
          return CreateReelsPage(listMediaPath: listMediaPath);
        },
      ),

      GoRoute(
        name: PathName.mediaPickedPage,
        path: AppPath.mediaPickedPage,
        builder: (context, state) {
          return MediaPickedPage();
        },
      ),
      GoRoute(
        name: PathName.cameraPage,
        path: AppPath.cameraPage,
        builder: (context, state) {
          return CameraPage();
        },
      ),
      GoRoute(
        name: PathName.listReelsPage,
        path: AppPath.listReelsPage,
        builder: (context, state) {
          final assetList = state.extra as List<ReelModel>;
          return StoryScreen(stories: assetList);
        },
      ),

      //Bottom Bar
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder:
            (context, state, navigationShell) =>
                MainPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomePage,
            routes: [
              GoRoute(
                name: PathName.homePage,
                path: AppPath.homePage,
                routes: [
                  GoRoute(
                    name: PathName.notificationPage,
                    path: AppPath.notificationPage,
                    builder: (context, state) {
                      return NotificationPage();
                    },
                  ),
                ],
                builder: (context, state) {
                  final extras = state.extra as Map<String, dynamic>? ?? {};
                  return HomePage(extras: extras);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchPage,
            routes: [
              GoRoute(
                name: PathName.searchPage,
                path: AppPath.searchPage,
                routes: [
                  GoRoute(
                    name: PathName.searchResultPage,
                    path: AppPath.searchResultPage,
                    builder: (context, state) {
                      return SearchResultPage();
                    },
                  ),
                ],
                builder: (context, state) {
                  return SearchPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorPostPage,
            routes: [
              GoRoute(
                name: PathName.createPage,
                path: AppPath.createPage,
                builder: (context, state) {
                  return PostPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorReelsPage,
            routes: [
              GoRoute(
                name: PathName.reelsPage,
                path: AppPath.reelsPage,
                builder: (context, state) {
                  return const ReelsPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorPersonalPage,
            routes: [
              GoRoute(
                name: PathName.personalPage,
                path: AppPath.personalPage,
                routes: [
                  GoRoute(
                    name: PathName.settingpage,
                    path: AppPath.settingpage,
                    builder: (context, state) {
                      return SettingPage();
                    },
                  ),
                ],
                builder: (context, state) {
                  return ProfilePage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
  static CustomTransitionPage slidePage(Widget child) => CustomTransitionPage(
    key: ValueKey(child.hashCode),
    child: child,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
