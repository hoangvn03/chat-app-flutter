import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white,
        backgroundColor: AppColors.white,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          // Reset page mỗi khi chuyển tab
          widget.navigationShell.goBranch(
            index,
            initialLocation: true, // ✅ Đây là key để reset page
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icHome),
            activeIcon: SvgPicture.asset(AppImages.icHomeActive),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icSearch),
            activeIcon: SvgPicture.asset(AppImages.icSearchActive),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icCreate),
            activeIcon: SvgPicture.asset(AppImages.icCreateActive),
            label: "Create Reels",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icReels),
            activeIcon: SvgPicture.asset(AppImages.icReelsActive),
            label: "Reels",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icPersonal),
            activeIcon: SvgPicture.asset(AppImages.icPersonalActive),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
