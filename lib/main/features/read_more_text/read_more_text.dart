import 'package:chat_app/main/features/read_more_text/read_more_cubit.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget readMoreDescription(BuildContext context, String text) {
  return BlocBuilder<ReadMoreCubit, bool>(
    builder: (context, expanded) {
      final defaultStyle = AppStyles.bodyRegular;
      final linkStyle = AppStyles.bodyRegular.copyWith(color: AppColors.gray40);
      if (expanded) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: text, style: defaultStyle),
              TextSpan(
                text: "… thu gọn",
                style: linkStyle,
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () => context.read<ReadMoreCubit>().toggle(),
              ),
            ],
          ),
        );
      } else {
        final span = TextSpan(text: text, style: defaultStyle);
        final tp = TextPainter(
          text: span,
          maxLines: 3,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: MediaQuery.of(context).size.width);

        String visibleText = text;
        if (tp.didExceedMaxLines) {
          final endIndex =
              tp.getPositionForOffset(Offset(tp.width, tp.height)).offset;
          visibleText = text.substring(0, endIndex);
        }
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: visibleText.trimRight(), style: defaultStyle),
              TextSpan(
                text: "… xem thêm",
                style: linkStyle,
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () => context.read<ReadMoreCubit>().toggle(),
              ),
            ],
          ),
        );
      }
    },
  );
}
