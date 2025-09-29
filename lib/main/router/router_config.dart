import 'package:chat_app/main/main_page.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/auth/login/login_page.dart';
import 'package:chat_app/main/ui/chat/chat_page.dart';
import 'package:chat_app/main/ui/home/home_page.dart';
import 'package:chat_app/main/ui/personal/personal_page.dart';
import 'package:chat_app/main/ui/post/post_page.dart';
import 'package:chat_app/main/ui/profile/profile_page.dart';
import 'package:chat_app/main/ui/reels/reels_page.dart';
import 'package:chat_app/main/ui/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          return ProfilePage();
        },
      ),
      GoRoute(
        name: PathName.chatPage,
        path: AppPath.chatPage,
        builder: (context, state) {
          return ChatPage();
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
                  return const PersonalPage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
