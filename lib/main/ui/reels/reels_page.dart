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

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Positioned(
              left: 0,
              right: 0,
              top: 32,
              child: _buildHeader(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(color: AppColors.green100),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final avatars = [
      AppImages.imgAvatarDefault,
      AppImages.imgAvatarDefault,
      AppImages.imgAvatarDefault,
    ];
    final fistUser = ['chaubui_'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'Reels',
                style: AppStyles.title2Bold.copyWith(color: AppColors.white),
              ),
              const SizedBox(width: 4),
              Transform.flip(
                flipY: true,
                child: SvgPicture.asset(
                  AppImages.icChevronUp,
                  width: 16,
                  height: 16,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'Bạn bè',
                style: AppStyles.title2Bold.copyWith(color: AppColors.gray60),
              ),
              const SizedBox(width: 4),

              totalUserFollow(
                ontap: () {
                  context.pushNamed(PathName.profileListFollowerPage);
                },
                images: avatars,
                fistUser: fistUser,
                isHideName: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentMedia(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTileItem(
                  title: 'Unknown',
                  subtitle: '1 ngày trước',
                  margin: EdgeInsets.zero,
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
                            Text(
                              'Unknown',
                              style: AppStyles.headlineBold.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              '1 ngày trước',
                              style: AppStyles.footnoteRegular.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        // followButton(),
                        interactionButton(
                          type: InteractionType.follow,
                          backgroundColor: Colors.transparent,
                          colorBorder: AppColors.white,
                          textStyle: AppStyles.bodyBold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trallingWidget: Container(),
                  onTapTralling: () {},
                ),
                readMoreDescription(
                  '''Everynight Alone
Đừng để giọt nước mắt vẫn rơi tàn hoa khắp nơi thiếu em babe
Everynight Alone
Lại gọi tên những nổi nhớ đong đầyBao đam mê cũng đã chóng phai
Yêu em ko biết đúng sai
Chỉ bằng cảm xúc bằng lý trí bằng tất cả những gì anh có
Hay em cho
Khi hai con tim lệch nhịp
Anh có cố gắng thế nào, em cũng không hiểu được em
Như là bản thân chính em.''',
                  textStyle: AppStyles.bodyRegular.copyWith(
                    color: AppColors.white,
                  ),
                  numLine: 1,
                ),
              ],
            ),
          ),
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
          child: SvgPicture.asset(AppImages.icOption, color: AppColors.white),
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
