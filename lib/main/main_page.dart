import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icHome),
            activeIcon: SvgPicture.asset(AppImages.icHomeActive),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icSearch),
            activeIcon: SvgPicture.asset(AppImages.icSearchActive),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icCreate),
            activeIcon: SvgPicture.asset(AppImages.icCreateActive),
            label: "Create Reels",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icReels),
            activeIcon: SvgPicture.asset(AppImages.icReelsActive),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.icPersonal),
            activeIcon: SvgPicture.asset(AppImages.icPersonalActive),
            label: "Home",
          ),
        ],
        selectedItemColor: AppColors.white,
        backgroundColor: AppColors.white,
        unselectedItemColor: AppColors.white,
        // selectedLabelStyle: AppStyles.inter12w500CenterH18,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) async {
          if (index == 2) {
            context.pushNamed(PathName.cameraPage);
          } else {
            widget.navigationShell.goBranch(index, initialLocation: false);
          }
        },

        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
