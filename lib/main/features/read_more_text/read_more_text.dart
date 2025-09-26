import 'package:chat_app/main/features/read_more_text/read_more_cubit.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget readMoreDescription(BuildContext context, String text) {
  return BlocBuilder<ReadMoreCubit, bool>(
    builder: (context, expanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: AppStyles.bodyRegular,
            maxLines: expanded ? null : 3,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          GestureDetector(
            onTap: () => context.read<ReadMoreCubit>().toggle(),
            child: Text(
              expanded ? "Thu gọn" : "Xem thêm",
              style: AppStyles.bodyRegular.copyWith(color: AppColors.gray40),
            ),
          ),
        ],
      );
    },
  );
}
