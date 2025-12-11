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
              context.goNamed(  PathName.homePage);
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
            BlocBuilder<ConversationsBloc, ConversationsState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.pushNamed(
                      PathName.createChatGroupPage,
                      extra: BlocProvider.of<CreateChatBloc>(context),
                    );
                  },
                  icon: SvgPicture.asset(
                    AppImages.icNoteCreate,
                    width: 24,
                    height: 24,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocListener<CreateChatBloc, CreateChatState>(
          listener: (context, state) {
            if (state is CreateChatSuccess && state.isCreateSuccess) {
              print('Create Success');
              context.read<ConversationsBloc>().add(LoadRequest());
            } else if (state is CreateChatFailure) {
              ScaffoldMessenger.of(
                context,
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.gray20,
        borderRadius: const BorderRadius.all(Radius.circular(32)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.icAddHighlight),
          const SizedBox(width: 16),
          Text('Hỏi Meta AI hoặc tìm kiếm', style: AppStyles.title3Regular),
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
        messages.isEmpty
            ? const SizedBox(height: 12)
            : ListView.builder(
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

  Widget _itemMessage(Conversation conversation, BuildContext con) {
    final participants = conversation.participants;

    // Nếu participants rỗng hoặc ít hơn 2, tránh crash
    if (participants.isEmpty || participants.length < 2) {
      return SizedBox(
        // height: 50,
        // child: Text(
        //   "Không có thông tin người tham gia",
        //   style: TextStyle(color: Colors.grey),
        // ),
      );
    }
    var listImage = [
      conversation.participants[0].avatar ?? AppImages.icStickers,
      conversation.participants[1].avatar ?? AppImages.icStickers,
    ];
    late UserModel userContact;
    if (!conversation.isGroup) {
      listImage = [conversation.participants[0].avatar ?? AppImages.icStickers];
    }
    for (var item in conversation.participants) {
      if (item.id != widget.currentUser.id) {
        userContact = item;
        break;
      }
    }
    return commonTileItemV2(
      onTap: () {
        if (conversation.isGroup) {
          con.pushNamed(
            PathName.chatRoomPage,
            extra: [conversation, widget.currentUser],
          );
        } else {
          con.pushNamed(
            PathName.chatRoomPage,
            extra: [conversation, userContact],
          );
        }
      },
      leadingWidget: groupUserAvatar(
        images:
            conversation.isGroup
                ? listImage
                : [userContact.avatar ?? AppImages.icStickers],
        avatarSize: conversation.isGroup ? 48 : 64,
      ),
      trallingWidget: SvgPicture.asset(AppImages.icCamera),
      title:
          conversation.isGroup
              ? conversation.conversationName ?? 'Unknown'
              : userContact.username ?? 'Unknown',
      subtitle:
          conversation.lastMessage?.content ?? 'Hãy gửi tin nhắn đầu tiên!',

      margin: EdgeInsets.symmetric(vertical: 12),
    );
  }
}
