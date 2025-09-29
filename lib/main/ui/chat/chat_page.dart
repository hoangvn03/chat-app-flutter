import 'package:chat_app/main/features/account_suggest/account_suggest_widget.dart';
import 'package:chat_app/main/features/post/post_widget.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_bloc.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_event.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc()..add(LoadRequest()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text("hoangvn03", style: AppStyles.title1Bold),
                const SizedBox(width: 8),
                Transform.flip(
                  flipY: true,
                  child: SvgPicture.asset(
                    AppImages.icChevronUp,
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Transform.flip(
              flipX: true,
              child: SvgPicture.asset(AppImages.icNextRight),
            ),
          ),
          actions: [
            PopupMenuButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: const BoxConstraints(),
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              offset: const Offset(40, 40),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.only(left: 24),
                      enabled: false, // tắt click
                      child: Text(
                        "Thông báo từ hoangvn03",
                        style: AppStyles.bodyRegular,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: ListTile(
                        dense: true,
                        leading: SvgPicture.asset(AppImages.icPictureGallery),
                        title: Text("Bài biết", style: AppStyles.title2Regular),
                        subtitle: Text(
                          "Phù hợp nhất",
                          style: AppStyles.bodyRegular,
                        ),
                        trailing: SvgPicture.asset(AppImages.icChevronRight),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: ListTile(
                        dense: true,

                        leading: SvgPicture.asset(AppImages.icAddHighlight),
                        title: Text("Tin", style: AppStyles.title2Regular),
                        subtitle: Text(
                          "Phù hợp nhất",
                          style: AppStyles.bodyRegular,
                        ),
                        trailing: SvgPicture.asset(AppImages.icChevronRight),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: ListTile(
                        dense: true,

                        leading: SvgPicture.asset(AppImages.icReels),
                        title: Text("Reels", style: AppStyles.title2Regular),
                        subtitle: Text(
                          "Phù hợp nhất",
                          style: AppStyles.bodyRegular,
                        ),
                        trailing: SvgPicture.asset(AppImages.icChevronRight),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: ListTile(
                        dense: true,

                        leading: SvgPicture.asset(AppImages.icLive),
                        title: Text(
                          "Video trực tiếp",
                          style: AppStyles.title2Regular,
                        ),
                        subtitle: Text(
                          "Phù hợp nhất",
                          style: AppStyles.bodyRegular,
                        ),
                        trailing: SvgPicture.asset(AppImages.icChevronRight),
                      ),
                    ),
                  ],
              child: Transform.flip(
                flipX: true,
                child: SvgPicture.asset(AppImages.icNotificationsOff),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Transform.rotate(
                angle: 90 * 3.1415926535 / 180, // xoay 90 độ (radian)
                child: SvgPicture.asset(AppImages.icOption),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 60),
                      userNote(
                        img: AppImages.imgAvatarDefault,
                        note: 'Bạn có gì mới vậy?',
                        subTitle: 'Ghi chú của bạn',
                      ),
                      const SizedBox(height: 16),
                      _buildListMessage([
                        MessageModel(
                          status: 'Đã gửi',
                          nameUserContact: 'Lisa',
                          userMessage: ['Hello'],
                          userContactMessage: ['Hi'],
                        ),
                        MessageModel(
                          status: 'Đã gửi',
                          nameUserContact: 'tuan_anh',
                          userMessage: ['Hello'],
                          userContactMessage: ['Hi'],
                        ),
                        MessageModel(
                          status: 'thanh_nguyen',
                          nameUserContact: 'Lisa',
                          userMessage: ['Hello'],
                          userContactMessage: ['Hi'],
                        ),
                      ]),
                      const SizedBox(height: 8),
                      AccountSuggestWidget(
                        isHorirontal: false,
                        title: 'Tài khoản nên theo dõi',
                        users: [
                          UserModel(
                            name: 'hieu_pham',
                            avatar: AppImages.imgAvatarDefault,
                          ),
                          UserModel(
                            name: 'tuan_anh',
                            avatar: AppImages.imgAvatarDefault,
                          ),
                          UserModel(
                            name: 'nguyen_nguyen',
                            avatar: AppImages.imgAvatarDefault,
                          ),
                          UserModel(
                            name: 'ngoc_hoang',
                            avatar: AppImages.imgAvatarDefault,
                          ),
                          UserModel(
                            name: 'minh_hieu',
                            avatar: AppImages.imgAvatarDefault,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ChatFailure) {
              return const Center(child: Text('Failed to load users'));
            }
            return const Center(child: Text('Welcome to the Chat Page!'));
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.icAddHighlight),
          const SizedBox(width: 16),
          Text('Hỏi Meta AI hoặc tìm kiếm'),
        ],
      ),
    );
  }

  Widget _buildListMessage(List<MessageModel> messages) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tin nhắn', style: AppStyles.title2Bold),
            Text(
              'Tin nhắn đang chờ',
              style: AppStyles.title2Bold.copyWith(color: AppColors.blue60),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true, // 👈 cho phép ListView co chiều cao theo item
          physics: NeverScrollableScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _itemMessage(messages[index]);
          },
        ),
      ],
    );
  }

  Widget _itemMessage(MessageModel message) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Image.asset(AppImages.imgAvatarDefault),
      title: Text(
        message.nameUserContact ?? 'Unknown',
        style: AppStyles.title2Regular,
      ),
      subtitle: Text(
        message.status ?? 'Có lỗi khi gửi',
        style: AppStyles.bodyRegular,
      ),
    );
  }
}
