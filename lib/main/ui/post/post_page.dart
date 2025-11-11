import 'package:chat_app/main/ui/widget/post/widgets/interaction_button.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          _buildMedia(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildContentMedia(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.green100
      ),
    );
  }

  Widget _buildContentMedia(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        commonTileItem(
          title: 'Unknown',
          subtitle: '1 ngày trước',
          titleWidget: GestureDetector(
            onTap: () {
              context.pushNamed(PathName.profilePage);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unknown', style: AppStyles.headlineBold),
                    Text('1 ngày trước', style: AppStyles.footnoteRegular),
                  ],
                ),
                // followButton(),
                interactionButton(type: InteractionType.follow),
              ],
            ),
          ),
          onTapTralling: () {
            // showModalBottomSheet(
            //   context: context,
            //   useSafeArea: true,
            //   backgroundColor: AppColors.white,
            //   isScrollControlled: true,
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            //   ),
            //   builder: (context) => _buildBottomSheetPostOption(context),
            // );
          },
        ),
        _buildListButton(),
      ],
    );
  }
}

Widget _buildListButton() {
  return Column(
    children: [
      IconButton(
        onPressed: () => debugPrint('P1'),
        icon: SvgPicture.asset(AppImages.icLike, color: AppColors.white),
      ),
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(AppImages.icComment, color: AppColors.white),
      ),
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(AppImages.icShare, color: AppColors.white),
      ),
      IconButton(
        onPressed: () {},
        icon: Transform.rotate(
          angle: 90 * 3.1415926535 / 180, // xoay 90 độ (radian)
          child: SvgPicture.asset(AppImages.icOption),
        ),
      ),
    ],
  );
}

Widget _buildTitle() {
  return Row(children: [

      ],
    );
}
