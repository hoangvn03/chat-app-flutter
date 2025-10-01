import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: Text('Thông báo', style: AppStyles.title1Bold),
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
      body: SingleChildScrollView(child: Column(children: [
            
          ],
        )),
    );
  }
}
