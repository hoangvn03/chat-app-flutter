import 'package:chat_app/main/ui/widget/post/widgets/interaction_button.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'benice_menswear',
        'subtitle':
            'đã đăng một thread mà bạn có thể sẽ thích: Everyday styling ideas 📸',
        'time': '4 giờ',
      },
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'junpham và 5 người khác',
        'subtitle': 'gần đây đã thêm vào tin của họ.',
        'time': '12 giờ',
      },
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'benice_menswear, jennierubyjane',
        'subtitle': 'và những người khác đã chia sẻ 104 ảnh.',
        'time': '17 giờ',
      },
    ];

    final older = [
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'Minh Hiệu, Thanh Thùy',
        'subtitle': 'và những người khác bạn có thể muốn theo dõi.',
        'time': '1 ngày',
      },
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'ngahh._4',
        'subtitle': 'đã đăng một thread mà bạn có thể sẽ thích.',
        'time': '2 ngày',
      },
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'quyetnguyenvan89',
        'subtitle': 'đang dùng Instagram.',
        'time': '2 ngày',
        'isFollow': true,
      },
      {
        'avatar': AppImages.imgAvatarDefault,
        'title': 'benice_menswear, jennierubyjane',
        'subtitle': 'và những người khác đã chia sẻ 94 ảnh.',
        'time': '3 ngày',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: Text('Thông báo', style: AppStyles.title1Bold),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Transform.flip(
            flipX: true,
            child: SvgPicture.asset(AppImages.icNextRight),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildFollowRequestItem(),
          const SizedBox(height: 16),
          _buildSectionTitle('Hôm qua'),
          ...notifications.map(_buildNotificationItem).toList(),
          const SizedBox(height: 16),
          _buildSectionTitle('7 ngày qua'),
          ...older.map(_buildNotificationItem).toList(),
        ],
      ),
    );
  }

  Widget _buildFollowRequestItem() {
    return commonTileItemV2(
      leadingWidget: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: AppColors.gray30),
        ),
        child: const Icon(Icons.person_add, color: Colors.black54),
      ),
      title: 'Yêu cầu theo dõi',
      subtitle: 'Phê duyệt hoặc bỏ qua yêu cầu',
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: AppStyles.title2Bold.copyWith(color: AppColors.black),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundImage: AssetImage(item['avatar'])),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppStyles.bodyRegular.copyWith(
                  color: AppColors.black,
                  height: 1.3,
                ),
                children: [
                  TextSpan(
                    text: '${item['title']} ',
                    style: AppStyles.bodyBold.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: item['subtitle']),
                  TextSpan(
                    text: '  ${item['time']}',
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.gray40,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item['isFollow'] == true)
            interactionButton(
              type: InteractionType.follow,
              backgroundColor: AppColors.blue40,
              colorBorder: AppColors.blue40,
              textStyle: AppStyles.bodyBold.copyWith(color: AppColors.white),
            ),
        ],
      ),
    );
  }
}
