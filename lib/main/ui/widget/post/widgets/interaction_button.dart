import 'package:chat_app/main/ui/widget/post/widgets/bloc/interaction_cubit.dart';
import 'package:chat_app/main/ui/widget/post/widgets/bloc/interaction_state.dart';
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
  Color? colorBorder,
  TextStyle? textStyle,
  InteractionType? type,
  dynamic data
}) {
  return BlocProvider(
    create: (_) => InteractionCubit(),
    child: BlocBuilder<InteractionCubit, InteractionState>(
      builder: (context, state) {
        final cubit = context.read<InteractionCubit>();
        switch (type) {
          case InteractionType.follow:
            return state.isFollowed
                ? commonButton(
                  hasHeight: true,
                  height: 28,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  margin: EdgeInsets.zero,
                  textStyle:
                      textStyle ??
                      AppStyles.bodyBold.copyWith(color: AppColors.gray80),
                  color: backgroundColor ?? AppColors.gray30,
                  colorBorder: colorBorder,
                  text: 'Đang theo dõi',
                  onTap: () {
                    cubit.toggleFollow();
                  },
                  radius: 6,
                )
                : commonButton(
                  hasHeight: true,
                  height: 28,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  margin: EdgeInsets.zero,
                  textStyle:
                      textStyle ??
                      AppStyles.bodyBold.copyWith(color: AppColors.gray80),
                  color: backgroundColor ?? AppColors.gray30,
                  colorBorder: colorBorder,
                  text: 'Theo dõi',
                  onTap: () {
                    cubit.toggleFollow();
                  },
                  radius: 6,
                );

          case InteractionType.like:
            return likeButton(
              context: context,
              icon: state.isLiked ? AppImages.icLikeDark : AppImages.icLike,
              onTap: () {
                if (onTapState2 != null) onTapState2();
                cubit.toggleLike();
              },
            );

          case InteractionType.save:
            return saveButton(
              context: context,
              icon: state.isSaved ? AppImages.icSaveDark : AppImages.icSave,
              onTap: () {
                if (onTapState1 != null) onTapState1();
                cubit.toggleSave();
              },
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
    create: (_) => InteractionCubit(),
    child: BlocBuilder<InteractionCubit, InteractionState>(
      builder: (context, state) {
        final cubit = context.read<InteractionCubit>();
        final defaultStyle = textStyle ?? AppStyles.bodyRegular;
        final linkStyle = AppStyles.bodyRegular.copyWith(
          color: AppColors.gray40,
        );
        // Trường hợp đang mở rộng
        if (state.isReadMore) {
          return Text.rich(
            textAlign: TextAlign.left,
            TextSpan(
              children: [
                TextSpan(text: text, style: defaultStyle),
                TextSpan(
                  text: "… thu gọn",
                  style: linkStyle,
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          cubit.toggleReadMore();
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
                          cubit.toggleReadMore();
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
  VoidCallback? onTap,
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
    onTap: onTap,
    radius: 6,
  );
}

Widget likeButton({
  String? icon,
  VoidCallback? onTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SvgPicture.asset(icon ?? AppImages.icLike, width: 24, height: 24),
  );
}

Widget saveButton({
  String? icon,
  VoidCallback? onTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SvgPicture.asset(icon ?? AppImages.icSave, width: 24, height: 24),
  );
}
