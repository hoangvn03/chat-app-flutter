import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  ChatRoom({super.key, required this.data});
  MessageModel data;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: GestureDetector(
          onTap: () {},
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Image.asset(
              AppImages.imgAvatarDefault,
              width: 28,
              height: 28,
            ),
            title: Text(
              widget.data.userModel != null
                  ? widget.data.userModel!.name ?? 'Unknown'
                  : 'Unknown',
              style: AppStyles.title2Bold,
            ),
            subtitle: Text(
              widget.data.userModel != null
                  ? widget.data.userModel!.email ?? 'Unknown Email'
                  : 'Unknown Email',
              style: AppStyles.headlineRegular,
            ),
          ),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 38),
              _buildInfoUserContact(
                MessageModel(
                  status: 'Đã gửi',
                  userModel: widget.data.userModel,
                  userMessage: ['Hello'],
                  userContactMessage: ['Hi'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoUserContact(MessageModel data) {
    return data.userModel != null
        ? Column(
          children: [
            Image.asset(
              AppImages.imgAvatarDefault,
              width: 86,
              height: 86,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 16),

            Text(
              data.userModel!.name ?? 'Unknown',
              style: AppStyles.title2Bold,
            ),

            Text(
              data.userModel!.email ?? 'Unknown Email',
              style: AppStyles.title3Regular,
            ),
            RichText(
              text: TextSpan(
                text: '106 triệu người theo dõi . ',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.gray60,
                ),
                children: [TextSpan(text: '1,1k bài viết')],
              ),
            ),
            Text(
              'Bạn đã theo dõi tài khoản Instagram này từ năm 2020',
              style: AppStyles.title3Regular.copyWith(color: AppColors.gray60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            commonButton(
              hasHeight: true,
              height: 28,
              margin: EdgeInsets.zero,
              color: AppColors.gray30,
              textStyle: AppStyles.bodyBold,
              text: 'Xem trang cá nhân',
              onTap: () {
                context.pushNamed(PathName.profilePage, extra: data.userModel);
              },
              radius: 6,
            ),
          ],
        )
        : Container();
  }
}
