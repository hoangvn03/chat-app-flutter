import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_state.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_bloc.dart';
import 'package:chat_app/main/ui/widget/account_suggest/account_suggest_widget.dart';
import 'package:chat_app/main/ui/widget/post/post_item_widget.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_bloc.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_event.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.currentUser});
  UserModel currentUser;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConversationsBloc()..add(LoadRequest())),
        BlocProvider(create: (_) => CreateChatBloc()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  widget.currentUser.username ?? 'Unknown',
                  style: AppStyles.title1Bold,
                ),
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
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppImages.icSearch),
            ),
            IconButton(
              onPressed: () {
                context.pushNamed(PathName.createChatGroupPage);
              },
              icon: SvgPicture.asset(
                AppImages.icNoteCreate,
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        body: BlocListener<CreateChatBloc, CreateChatState>(
          listener: (con, state) {
            if (state is CreateChatSuccess) {
              con.pushNamed(
                PathName.chatRoomPage,
                extra: [state.conversationId, null], // 👈 truyền ID sang
              );
            } else if (state is CreateChatFailure) {
              ScaffoldMessenger.of(
                con,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: BlocBuilder<ConversationsBloc, ConversationsState>(
            builder: (context, state) {
              if (state is ConversationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ConversationsSuccess) {
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
                          img:
                              widget.currentUser.avatar ??
                              'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
                          note: 'Bạn có gì mới vậy?',
                          subTitle: 'Ghi chú của bạn',
                        ),
                        const SizedBox(height: 16),
                        _buildListMessage(state.data!.conversations, context),
                        const SizedBox(height: 16),
                        AccountSuggestWidget(
                          isHorirontal: false,
                          title: 'Tài khoản nên theo dõi',
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
                              username: 'nguyen_nguyen',
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
                      ],
                    ),
                  ),
                );
              } else if (state is ConversationsFailure) {
                return Center(child: Text(state.errorMessage));
              }
              return const Center(child: Text('Welcome to the Chat Page!'));
            },
          ),
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

  Widget _buildListMessage(List<Conversation> messages, BuildContext con) {
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
            return _itemMessage(messages[index], con);
          },
        ),
      ],
    );
  }

  Widget _itemMessage(Conversation con, BuildContext context) {
    var listImage = [
      con.participants[0].avatar ?? AppImages.icStickers,
      con.participants[1].avatar ?? AppImages.icStickers,
    ];
    if (!con.isGroup) {
      listImage = [con.participants[1].avatar ?? AppImages.icStickers];
    }
    return commonTileItemV2(
      onTap: () {
        context.pushNamed(
          PathName.chatRoomPage,
          extra: con, // 👈 truyền ID sang
        );
      },
      leadingWidget: groupUserAvatar(
        images: listImage,
        avatarSize: con.isGroup ? 48 : 64,
      ),
      trallingWidget: SvgPicture.asset(AppImages.icCamera),
      title: con.conversationName ?? 'Unknown',
      subtitle:
          con.isGroup
              ? con.lastMessage?.content ?? 'Hãy gửi tin nhắn đầu tiên!'
              : con.lastMessage?.content ?? con.participants[1].status,
      margin: EdgeInsets.symmetric(vertical: 12),
    );
  }
}
