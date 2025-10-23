import 'package:chat_app/main/ui/widget/account_suggest/cubit/account_suggest_cubit.dart';
import 'package:chat_app/main/ui/widget/account_suggest/cubit/account_suggest_state.dart';
import 'package:chat_app/main/ui/widget/interaction_button/interaction_button.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class AccountSuggestWidget extends StatelessWidget {
  AccountSuggestWidget({
    super.key,
    required this.isHorirontal,
    required this.users,
    this.title,
  });
  bool isHorirontal;
  String? title;
  List<UserModel> users;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountSuggestCubit()..loadRequest(),
      child: BlocBuilder<AccountSuggestCubit, AccountSuggestState>(
        builder: (context, state) {
          if (state is AccountSuggestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountSuggestSuccess) {
            final data = state.contactList;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title ?? '', style: AppStyles.title2Bold),
                    Text(
                      'Xem tất cả',
                      style: AppStyles.title2Bold.copyWith(
                        color: AppColors.blue60,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                isHorirontal
                    ? SizedBox(
                      height:
                          185, // or whatever height fits your horizontal item
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 4),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return _itemUserSuggestV2(
                            data[index].friend!,
                            context,
                          );
                        },
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder:
                          (context, index) =>
                              _itemUserSuggestV1(data[index].friend!, context),
                    ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _itemUserSuggestV1(UserModel user, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: SvgPicture.network(
        user.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
        width: 68,
        height: 68,
      ),
      title: Text(user.username ?? 'Unknown', style: AppStyles.title2Bold),
      subtitle: Text('Gợi ý cho bạn', style: AppStyles.bodyRegular),
      onTap: () {
        context.pushNamed(PathName.profilePage, extra: user);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: interactionButton(
              type: InteractionType.follow,
              backgroundColor: AppColors.blue40,
              colorBorder: AppColors.blue40,
              textStyle: AppStyles.bodyBold.copyWith(color: AppColors.white),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(AppImages.icClose, width: 16, height: 16),
          ),
        ],
      ),
    );
  }

  Widget _itemUserSuggestV2(UserModel user, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(PathName.profilePage, extra: user);
      },
      child: Container(
        width: 140,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.gray20,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: SvgPicture.network(
                      user.avatar ??
                          'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
                      width: 68,
                      height: 68,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    AppImages.icClose,
                    width: 16,
                    height: 16,
                    color: AppColors.gray60,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(user.username ?? 'Unknown', style: AppStyles.headlineBold),
            const SizedBox(height: 2),
            Text('Gợi ý cho bạn', style: AppStyles.calloutRegular),
            const SizedBox(height: 16),
            commonButton(
              hasHeight: true,
              margin: EdgeInsets.zero,
              height: 28,
              padding: EdgeInsets.zero,
              textStyle: AppStyles.bodyBold.copyWith(color: AppColors.white),
              text: 'Theo dõi',
              onTap: () {},
              radius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
