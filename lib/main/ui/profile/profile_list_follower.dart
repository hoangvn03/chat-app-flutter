import 'package:chat_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileListFollowerPage extends StatelessWidget {
  const ProfileListFollowerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Transform.flip(
            flipX: true,
            child: SvgPicture.asset(AppImages.icNextRight),
          ),
        ),
      ),
      body: Center(
        child: Text('List Follower Profile'),
      ),
    );
  }
}
