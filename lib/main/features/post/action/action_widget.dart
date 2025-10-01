import 'package:chat_app/main/features/interaction_button/bloc/interaction_bloc.dart';
import 'package:chat_app/main/features/interaction_button/interaction_button.dart';
import 'package:chat_app/main/features/post/action/bloc/action_bloc.dart';
import 'package:chat_app/main/features/post/action/bloc/action_event.dart';
import 'package:chat_app/main/features/post/action/bloc/action_state.dart';
import 'package:chat_app/main/networks/model/comment.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

Widget commentPageBottomSheet() {
  return BlocProvider(
    create: (_) => ActionBloc()..add(LoadRequest()),
    child: BlocBuilder<ActionBloc, ActionState>(
      builder: (context, state) {
        if (state is ActionSuccess) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
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
                      ListView.builder(
                        shrinkWrap:
                            true, // 👈 cho phép ListView co chiều cao theo item
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          return commentItem(state.comments[index]);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: commentTextField(),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('Lỗi'));
        }
      },
    ),
  );
}

Widget sharePageBottomSheet() {
  return Container();
}

Widget savePageBottomSheet() {
  return Container();
}

Widget commentItem(CommentItemModel item) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        GestureDetector(
          onTap: () {},
          child: cricleColorImage(
            size: 34,
            hasReelsBorder: true,
            hasReels: true,
            childWidget: Image.asset(
              AppImages.imgAvatarDefault,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Nội dung comment
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppStyles.bodyRegular, // 👈 cần có style
                  children: [
                    TextSpan(
                      text: item.user.name ?? 'Unknown',
                      style: AppStyles.calloutBold,
                    ),
                    TextSpan(
                      text:
                          "  •  ${item.createdAt}", // bạn format datetime ra string
                      style: AppStyles.footnoteRegular,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(item.text, style: AppStyles.bodyRegular),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: Text('Trả lời', style: AppStyles.footnoteRegular),
              ),
            ],
          ),
        ),

        // Like + count
        Column(
          children: [
            interactionButton(type: InteractionType.like),
            const SizedBox(height: 4),
            Text('${item.likesCount}', style: AppStyles.footnoteRegular),
          ],
        ),
      ],
    ),
  );
}

Widget commentTextField() {
  return commonTextField();
}
