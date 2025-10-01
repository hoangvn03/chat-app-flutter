import 'package:chat_app/main/features/interaction_button/bloc/interaction_bloc.dart';
import 'package:chat_app/main/features/interaction_button/bloc/interaction_event.dart';
import 'package:chat_app/main/features/interaction_button/bloc/interaction_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

enum InteractionType { follow, like, save, share, readMore }

Widget interactionButton({
  Widget? initWidget,
  Widget? onClickWidget,
  Function? onTapState1,
  Function? onTapState2,
  Color? backgroundColor,
  TextStyle? textStyle,
  InteractionType? type,
}) {
  return BlocProvider(
    create: (_) => InteractionBloc(),
    child: BlocBuilder<InteractionBloc, InteractionState>(
      builder: (context, state) {
        switch (type) {
          case InteractionType.follow:
            return state.isFollowed
                ? followButtonV2(context: context, text: 'Đang theo dõi')
                : followButtonV2(context: context, text: 'Theo dõi');

          case InteractionType.like:
            return likeButton(
              context: context,
              icon: state.isLiked ? AppImages.icLikeDark : AppImages.icLike,
            );

          case InteractionType.save:
            return saveButton(
              context: context,
              onTapState1: onTapState1,
              icon: state.isSaved ? AppImages.icSaveDark : AppImages.icSave,
            );

          // case InteractionType.readMore:
          //   return likeButton(
          //     context: context,
          //     icon: state.isReadMore ? AppImages.icSaveDark : AppImages.icClose,
          //   );

          // case InteractionType.share:
          //   return likeButton(
          //     context: context,
          //     icon: AppImages.icShare,
          //   );

          default:
            return const SizedBox.shrink();
        }
      },
    ),
  );
}

Widget readMoreDescription(
  String text, {
  TextStyle? textStyle,
  int numLine = 3,
}) {
  return BlocProvider(
    create: (_) => InteractionBloc(),
    child: BlocBuilder<InteractionBloc, InteractionState>(
      builder: (context, state) {
        final defaultStyle = textStyle ?? AppStyles.bodyRegular;
        final linkStyle = AppStyles.bodyRegular.copyWith(
          color: AppColors.gray40,
        );
        // Trường hợp đang mở rộng
        if (state.isReadMore) {
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: text, style: defaultStyle),
                TextSpan(
                  text: "… thu gọn",
                  style: linkStyle,
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          context.read<InteractionBloc>().add(ReadMore());
                        },
                ),
              ],
            ),
          );
        } else {
          // Đo text để biết có vượt numLine hay không
          final span = TextSpan(text: text, style: defaultStyle);
          final tp = TextPainter(
            text: span,
            maxLines: numLine,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: MediaQuery.of(context).size.width);

          if (!tp.didExceedMaxLines) {
            return Text(text, style: defaultStyle);
          }
          final endIndex =
              tp.getPositionForOffset(Offset(tp.width, tp.height)).offset;
          final visibleText = text.substring(0, endIndex);

          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: visibleText.trimRight(), style: defaultStyle),
                TextSpan(
                  text: "… xem thêm",
                  style: linkStyle,
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          context.read<InteractionBloc>().add(ReadMore());
                        },
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}

Widget followButtonV2({
  Widget? initWidget,
  Widget? onClickWidget,
  Function? onTapState1,
  Function? onTapState2,
  Color? backgroundColor,
  TextStyle? textStyle,
  String? text,
  required BuildContext context,
}) {
  return commonButton(
    hasHeight: true,
    height: 28,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    margin: EdgeInsets.zero,
    textStyle:
        textStyle ?? AppStyles.bodyBold.copyWith(color: AppColors.gray80),
    color: backgroundColor ?? AppColors.gray30,
    colorBorder: backgroundColor ?? AppColors.gray30,
    text: text ?? 'Đang theo dõi',
    onTap: () {
      onTapState2;
      context.read<InteractionBloc>().add(FollowUser());
    },
    radius: 6,
  );
}

Widget likeButton({
  String? icon,
  Function? onTapState1,
  Function? onTapState2,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      onTapState1;
      context.read<InteractionBloc>().add(LikePost());
    },
    child: SvgPicture.asset(icon ?? AppImages.icLike, width: 24, height: 24),
  );
}

Widget saveButton({
  String? icon,
  Function? onTapState1,
  Function? onTapState2,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      if (onTapState1 != null) onTapState1(); 
      context.read<InteractionBloc>().add(SavePost());
    },
    child: SvgPicture.asset(icon ?? AppImages.icSave, width: 24, height: 24),
  );
}

// Widget saveButton({
//   Widget? initWidget,
//   Widget? onClickWidget,
//   Function? onTapState1,
//   Function? onTapState2,
// }) {
//   return BlocBuilder<InteractionBloc, InteractionState>(
//     builder: (context, state) {
//       if (!state.isSaved) {
//         return GestureDetector(
//           onTap: () {
//             onTapState1;
//             context.read<InteractionBloc>().add(SavePost());
//           },
//           child:
//               initWidget ??
//               SvgPicture.asset(AppImages.icSave, width: 24, height: 24),
//         );
//       } else {
//         return GestureDetector(
//           onTap: () {
//             onTapState2;
//             context.read<InteractionBloc>().add(SavePost());
//           },
//           child:
//               onClickWidget ??
//               SvgPicture.asset(AppImages.icSaveDark, width: 24, height: 24),
//         );
//       }
//     },
//   );
// }
// Widget followButton({
//   Widget? initWidget,
//   Widget? onClickWidget,
//   Function? onTapState1,
//   Function? onTapState2,
//   Color? backgroundColor,
//   TextStyle? textStyle,
// }) {
//   return BlocBuilder<InteractionBloc, InteractionState>(
//     builder: (context, state) {
//       if (!state.isFollowed) {
//         return initWidget ??
//             commonButton(
//               hasHeight: true,
//               height: 28,
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//               margin: EdgeInsets.zero,
//               textStyle: AppStyles.bodyBold.copyWith(color: AppColors.gray80),
//               color: backgroundColor ?? AppColors.gray30,
//               colorBorder: backgroundColor ?? AppColors.gray30,
//               text: 'Theo dõi',
//               onTap: () {
//                 onTapState1;
//                 context.read<InteractionBloc>().add(FollowUser());
//               },
//               radius: 6,
//             );
//       } else {
//         return onClickWidget ??
//             commonButton(
//               hasHeight: true,
//               height: 28,
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//               margin: EdgeInsets.zero,
//               textStyle:
//                   textStyle ??
//                   AppStyles.bodyBold.copyWith(color: AppColors.gray80),
//               color: backgroundColor ?? AppColors.gray30,
//               colorBorder: backgroundColor ?? AppColors.gray30,
//               text: 'Đang theo dõi',
//               onTap: () {
//                 onTapState2;
//                 context.read<InteractionBloc>().add(FollowUser());
//               },
//               radius: 6,
//             );
//       }
//     },
//   );
// }
