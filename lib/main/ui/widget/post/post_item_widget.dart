import 'package:chat_app/main/ui/widget/post/widgets/bloc/interaction_state.dart';
import 'package:chat_app/main/ui/widget/post/widgets/interaction_button.dart';
import 'package:chat_app/main/ui/widget/post/widgets/bloc/interaction_cubit.dart';
import 'package:chat_app/main/ui/widget/post/widgets/action_widget.dart';
import 'package:chat_app/main/ui/widget/post/bloc/action_bloc.dart';
import 'package:chat_app/main/ui/widget/post/bloc/action_event.dart';
import 'package:chat_app/main/ui/widget/post/bloc/action_state.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  PostWidget({super.key, required this.post});
  PostModel post;
  final TextEditingController _commetController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          // _buildHeaderPost(context),
          commonTileItem(
            title: post.author!.username ?? 'Unknown',
            subtitle: formatDateTimeV2(post.updatedAt),
            titleWidget: GestureDetector(
              onTap: () {
                context.pushNamed(PathName.profilePage, extra: post.author);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author!.username ?? 'Unknown',
                        style: AppStyles.headlineBold,
                      ),
                      Text(
                        formatDateTimeV2(post.updatedAt),
                        style: AppStyles.footnoteRegular,
                      ),
                    ],
                  ),
                  // followButton(),
                  interactionButton(type: InteractionType.follow),
                ],
              ),
            ),
            onTapTralling: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                backgroundColor: AppColors.white,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _buildBottomSheetPostOption(context),
              );
            },
          ),

          // Post Image
          _buildPostContent(),

          // Action bar
          _buildActionBar(context),

          //User Like
          _buildListUserLikePost(
            users: [
              UserModel(
                id: 999,
                username: 'hieu_pham',
                avatar: AppImages.imgAvatarDefault,
              ),
              UserModel(
                id: 999,
                username: 'tuan_anh',
                avatar: AppImages.imgAvatarDefault,
              ),
              UserModel(
                id: 999,
                username: 'ngoc_hoang',
                avatar: AppImages.imgAvatarDefault,
              ),
              UserModel(
                id: 999,
                username: 'minh_hieu',
                avatar: AppImages.imgAvatarDefault,
              ),
            ],
          ),
          // Caption
          _builCaptionPost(),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    final mediaList = post.media ?? [];

    if (mediaList.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('Không có ảnh')),
      );
    }

    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          final media = mediaList[index];
          return Image.network(
            media.mediaUrl ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image)),
          );
        },
      ),
    );
  }

  Widget _buildActionBar(BuildContext con) {
    print('IsLikes: ${post.isLiked} ${post.likesCount}');
    return BlocBuilder<ActionBloc, ActionState>(
      builder: (con, state) {
        var likeCount, isSelected, cmtCount, shareCount;
        if (state is ActionSuccess) {
          likeCount = (state.data != null) ? state.data : post.likesCount;
          cmtCount =
              (state.cmtCount != null) ? state.cmtCount : post.commentsCount;
          shareCount =
              (state.shareCount != null) ? state.shareCount : post.saveCount;

          isSelected = state.isSelected;
        } else {
          isSelected = post.isLiked;
          likeCount = post.likesCount ?? 0;
          cmtCount = post.commentsCount ?? 0;
          shareCount = post.saveCount ?? 0;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              likeButton(
                context: con,
                icon: isSelected ? AppImages.icLikeDark : AppImages.icLike,
                onTap: () {
                  con.read<ActionBloc>().add(
                    ActionPost(
                      typeAction: InteractionType.like,
                      postId: post.postId ?? -1,
                    ),
                  );
                },
              ),

              // interactionButton(type: InteractionType.like),
              SizedBox(width: 4),
              Text('$likeCount', style: AppStyles.calloutBold),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: con,
                    useSafeArea: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return BlocProvider.value(
                        value: BlocProvider.of<ActionBloc>(con),
                        child: CommentWidget(
                          textController: _commetController,
                          postId: post.postId ?? -1,
                          postModel: post,
                        ),
                      );
                    },
                  );
                },
                child: SvgPicture.asset(
                  AppImages.icComment,
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 4),
              Text('$cmtCount', style: AppStyles.calloutBold),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: con,
                    useSafeArea: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return CommentWidget(
                        textController: _commetController,
                        postId: post.postId ?? -1,
                        postModel: post,
                      );
                    },
                  );
                },
                child: SvgPicture.asset(
                  AppImages.icShare,
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '$shareCount',
                style: AppStyles.calloutBold,
              ), // Sửa thành comments count
              Spacer(),
              interactionButton(
                type: InteractionType.save,
                onTapState1: () {
                  showModalBottomSheet(
                    context: con,
                    useSafeArea: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return CommentWidget(
                        textController: _commetController,
                        postId: post.postId ?? -1,
                        postModel: post,
                      );
                    },
                  );
                },
              ),

              // saveButton(),
            ],
          ),
        );
      },
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
                height: 24,
                width: 24,
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
                            text: " ${users[0].username}",
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${post.author!.username ?? ''} ',
            style: AppStyles.headlineBold,
          ),
          Expanded(
            child: readMoreDescription(
              " ${post.caption}",
              textStyle: AppStyles.bodyRegular,
              numLine: 2,
            ),
          ),
        ],
      ),

      // RichText(
      //   text: TextSpan(
      //     children: [
      //       TextSpan(text: " ${post.caption}", style: AppStyles.bodyRegular),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildBottomSheetPostOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: Container(
                margin: EdgeInsets.only(top: 7),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.gray30,
                ),
                height: 4,
                width: 32,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Hạn chế',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.red100,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Chặn',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.red100,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Báo cáo',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.red100,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Giới thiệu về tài khoản này',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Xem hoạt động chung',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Ẩn tin của bạn',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Sao chép URL trang cá nhân',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Chia sẻ trang cá nhân này',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Mã URL',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  // Widget _buildHeaderPost(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           child: cricleColorImage(
  //             size: 34,
  //             childWidget: Image.asset(
  //               AppImages.imgAvatarDefault, // ảnh PNG/JPG
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           onTap: () {
  //             context.pushNamed(PathName.profilePage, extra: post.user);
  //           },
  //         ),
  //         SizedBox(width: 8),
  //         GestureDetector(
  //           onTap: () {
  //             context.pushNamed(PathName.profilePage, extra: post.user);
  //           },
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 post.user.username ?? 'Unknown',
  //                 style: AppStyles.headlineBold,
  //               ),
  //               Text(
  //                 post.timePost ?? '1 ngày trước',
  //                 style: AppStyles.footnoteRegular,
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(child: SizedBox(height: 8)),
  //         InkWell(
  //           onTap: () {
  //             //todo
  //           },
  //           child: Transform.rotate(
  //             angle: 90 * 3.1415926535 / 180, // xoay 90 độ (radian)
  //             child: SvgPicture.asset(AppImages.icOption),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
