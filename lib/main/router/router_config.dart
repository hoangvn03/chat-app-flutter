import 'package:chat_app/main/main_page.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/auth/login/login_page.dart';
import 'package:chat_app/main/ui/chat/chat_page.dart';
import 'package:chat_app/main/ui/chat/chat_room.dart';
import 'package:chat_app/main/ui/home/home_page.dart';
import 'package:chat_app/main/ui/personal/personal_page.dart';
import 'package:chat_app/main/ui/post/post_page.dart';
import 'package:chat_app/main/ui/profile/profile_list_follower.dart';
import 'package:chat_app/main/ui/profile/profile_page.dart';
import 'package:chat_app/main/ui/reels/camera/camera_page.dart';
import 'package:chat_app/main/ui/reels/create_reels/create_reels_page.dart';
import 'package:chat_app/main/ui/reels/list_reels/list_reels_page.dart';
import 'package:chat_app/main/ui/reels/media_picked/media_picked_page.dart';
import 'package:chat_app/main/ui/reels/reels_page.dart';
import 'package:chat_app/main/ui/search/search_page.dart';
import 'package:chat_app/main/ui/search/search_result_page.dart';
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
        name: PathName.chatPage,
        path: AppPath.chatPage,
        builder: (context, state) {
          return ChatPage();
        },
      ),
      GoRoute(
        name: PathName.chatRoomPage,
        path: AppPath.chatRoomPage,
        builder: (context, state) {
          final data = state.extra as MessageModel;
          return ChatRoom(data: data);
        },
      ),
      GoRoute(
        name: PathName.profileListFollowerPage,
        path: AppPath.profileListFollowerPage,
        builder: (context, state) {
          return ProfileListFollowerPage();
        },
      ),
      GoRoute(
        name: PathName.createReelsPage,
        path: AppPath.createReelsPage,
        builder: (context, state) {
          final listImagePath = state.extra as List<dynamic>;
          return CreateReelsPage(listImagePath: listImagePath);
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
                builder: (context, state) {
                  return HomePage();
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
}
