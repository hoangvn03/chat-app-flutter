import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_images.dart';
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
          userContactName: "Hieu",
          userContactImage: AppImages.imgAvatarDefault,
        ),

        // Caption
        _builCaptionPost(),

        // Time ago
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            post.timeAgo ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeaderPost(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          InkWell(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.username ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(post.timePost ?? '1 ngày trước'),
            ],
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
          SvgPicture.asset(AppImages.icLike),
          SizedBox(width: 4),
          Text(
            '${post.likes}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 12),
          SvgPicture.asset(AppImages.icComment),
          SizedBox(width: 4),
          Text(
            '${post.likes}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 12),
          SvgPicture.asset(AppImages.icShare),
          SizedBox(width: 4),
          Text(
            '${post.likes}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          SvgPicture.asset(AppImages.icSave),
        ],
      ),
    );
  }

  Widget _buildListUserLikePost({
    String? userContactName,
    String? userContactImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            margin: EdgeInsets.only(right: 4),
            width: 16,
            height: 16,
            child: Image.asset(userContactImage ?? AppImages.imgAvatarDefault),
          ),
          Text('Có $userContactName và những người khác thích'),
        ],
      ),
    );
  }

  Widget _builCaptionPost() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: post.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: " ${post.caption}",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
