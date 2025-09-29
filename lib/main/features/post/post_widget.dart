import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  UserModel? user;
  PostWidget({super.key, required this.post, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeaderPost(context),

        // Post Image
        _buildPostContent(),

        // Action bar
        _buildActionBar(),

        //User Like
        _buildListUserLikePost(
          users: [
            UserModel(name: 'hieu_pham', avatar: AppImages.imgAvatarDefault),
            UserModel(name: 'tuan_anh', avatar: AppImages.imgAvatarDefault),
            UserModel(
              name: 'nguyen_nguyen',
              avatar: AppImages.imgAvatarDefault,
            ),
            UserModel(name: 'ngoc_hoang', avatar: AppImages.imgAvatarDefault),
            UserModel(name: 'minh_hieu', avatar: AppImages.imgAvatarDefault),
          ],
        ),
        // Caption
        _builCaptionPost(),
      ],
    );
  }

  Widget _buildHeaderPost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          GestureDetector(
            child: cricleColorImage(
              size: 34,
              childWidget: Image.asset(
                AppImages.imgAvatarDefault, // ảnh PNG/JPG
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              context.pushNamed(PathName.profilePage);
            },
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              context.pushNamed(PathName.profilePage);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.username ?? 'Unknown', style: AppStyles.headlineBold),
                Text(
                  post.timePost ?? '1 ngày trước',
                  style: AppStyles.footnoteRegular,
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox(height: 8)),
          InkWell(
            onTap: () {
              //todo
            },
            child: Transform.rotate(
              angle: 90 * 3.1415926535 / 180, // xoay 90 độ (radian)
              child: SvgPicture.asset(AppImages.icOption),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Image.network(
      post.postImage ?? '',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 300,
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          SvgPicture.asset(AppImages.icLike, width: 24, height: 24),
          SizedBox(width: 4),
          Text('${post.likes}', style: AppStyles.calloutBold),
          SizedBox(width: 12),
          SvgPicture.asset(AppImages.icComment, width: 24, height: 24),
          SizedBox(width: 4),
          Text('${post.likes}', style: AppStyles.calloutBold),

          SizedBox(width: 12),
          SvgPicture.asset(AppImages.icShare, width: 24, height: 24),
          SizedBox(width: 4),
          Text('${post.likes}', style: AppStyles.calloutBold),

          Spacer(),
          SvgPicture.asset(AppImages.icSave, width: 24, height: 24),
        ],
      ),
    );
  }

  Widget _buildListUserLikePost({List<UserModel>? users}) {
    return users != null
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
                width: 16,
                child: Stack(
                  clipBehavior: Clip.none,
                  children:
                      List.generate(1, (index) {
                        return Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              users[index].avatar ?? AppImages.imgAvatarDefault,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).reversed.toList(),
                ),
              ),
              const SizedBox(width: 4),
              if (users.length >= 2)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //Todo
                    },
                    child: RichText(
                      softWrap: true,
                      text: TextSpan(
                        text: 'Có',
                        style: AppStyles.bodyRegular,
                        children: [
                          TextSpan(
                            text: " ${users[0].name}",
                            style: AppStyles.bodyBold,
                          ),
                          TextSpan(
                            text: " và", // 👈 text giống Insta
                            style: AppStyles.bodyRegular,
                          ),
                          TextSpan(
                            text:
                                " những người khác thích", // 👈 text giống Insta
                            style: AppStyles.bodyBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
        : Container();
  }

  Widget _builCaptionPost() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: post.username, style: AppStyles.headlineBold),
            TextSpan(text: " ${post.caption}", style: AppStyles.bodyRegular),
          ],
        ),
      ),
    );
  }
}
