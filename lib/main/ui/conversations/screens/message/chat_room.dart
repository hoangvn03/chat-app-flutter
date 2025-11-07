import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/conversations/screens/message/audio_chat/bloc/audio_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_state.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/main/ui/reels/media_picked/widget/media_option_header.dart';
import 'package:chat_app/main/ui/reels/media_picked/widget/media_picked.dart';
import 'package:chat_app/main/ui/reels/media_picked/widget/all_album_media.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:photo_manager/photo_manager.dart';

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  ChatRoom({super.key, required this.conversation});
  final Conversation conversation;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  ChatBloc(context.read<SocketService>())
                    ..add(LoadMessage(widget.conversation)),
        ),
        BlocProvider(create: (_) => AudioBloc()),
        BlocProvider(
          create:
              (_) =>
                  MediaPickedBloc()..add(
                    LoadRequest(requestType: RequestType.common, maxCount: 5),
                  ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: GestureDetector(
            onTap: () {},
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Image.asset(
                AppImages.imgAvatarDefault,
                width: 28,
                height: 28,
              ),
              title: Text(
                widget.conversation.isGroup
                    ? widget.conversation.conversationName ?? 'Unknown'
                    : widget.conversation.participants[1].username ?? 'Unknown',
                style: AppStyles.title2Bold,
              ),
              subtitle:
                  widget.conversation.isGroup
                      ? _buildListUserOnline()
                      : _buildStatusUserContact(),
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
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          children: [
                            const SizedBox(height: 38),
                            _buildInfoUserContact(),
                            const SizedBox(height: 58),
                            BlocSelector<
                              ChatBloc,
                              ChatState,
                              List<MessageEntity>
                            >(
                              selector: (state) {
                                if (state is ChatSuccess) {
                                  return state.messages ?? [];
                                }
                                return [];
                              },
                              builder: (context, messages) {
                                return _buildListMessage(messages);
                              },
                            ),
                            BlocSelector<ChatBloc, ChatState, List<UserModel>>(
                              selector: (state) {
                                if (state is ChatSuccess &&
                                    state.typingUsers != null) {
                                  print(state.typingUsers!.length);
                                  return state.typingUsers ?? [];
                                }
                                return [];
                              },
                              builder: (context, data) {
                                return _buildTypingIndicator(data);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: _buildTextFieldMessage(context),
                  ),
                ],
              );
            } else if (state is ChatFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return const Text('nnnn');
          },
        ),
      ),
    );
  }

  Widget _buildInfoUserContact() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppImages.imgAvatarDefault,
          width: 86,
          height: 86,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 16),

        Text(
          widget.conversation.isGroup
              ? widget.conversation.conversationName ?? 'Unknown'
              : widget.conversation.participants[1].username ?? 'Unknown',
          style: AppStyles.title2Bold,
        ),
        RichText(
          text: TextSpan(
            text: '106 triệu người theo dõi . ',
            style: AppStyles.title3Regular.copyWith(color: AppColors.gray60),
            children: [TextSpan(text: '1,1k bài viết')],
          ),
        ),
        Text(
          'Bạn đã theo dõi tài khoản Instagram này từ năm 2020',
          style: AppStyles.title3Regular.copyWith(color: AppColors.gray60),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        IntrinsicWidth(
          child: commonButton(
            margin: EdgeInsets.zero,
            hasHeight: false,
            padding: EdgeInsets.all(8),
            color: AppColors.gray20,
            textStyle: AppStyles.bodyBold,
            text: 'Xem trang cá nhân',
            onTap: () {
              context.pushNamed(
                PathName.profilePage,
                extra:
                    widget.conversation.isGroup
                        ? widget.conversation.participants[1]
                        : widget.conversation.participants[1],
              );
            },
            radius: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildListMessage(List<MessageEntity> messages) {
    print('${messages.length}');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _itemMessage(msg);
      },
    );
  }

  Widget _buildTypingIndicator(List<UserModel> users) {
    if (users.isEmpty) {
      return const SizedBox();
    }

    String text;
    if (users.length == 1) {
      text = '${users.first.username} đang nhập...';
    } else if (users.length == 2) {
      text = '${users[0].username} và ${users[1].username} đang nhập...';
    } else {
      text =
          '${users.sublist(0, users.length - 1).join(", ")} và ${users.last.username} đang nhập...';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.edit, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldMessage(BuildContext context) {
    return commonTextFieldV2(
      radius: 32,
      height: 56,
      margin: EdgeInsets.zero,
      controller: _messageController,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      onChanged: (value) {
        if (value.isNotEmpty) {
          context.read<ChatBloc>().add(
            UserTypingOrStopTypingEvent(
              conversationId: widget.conversation.conversationId,
              isStop: false,
            ),
          );
        } else {
          context.read<ChatBloc>().add(
            UserTypingOrStopTypingEvent(
              conversationId: widget.conversation.conversationId,
              isStop: true,
            ),
          );
        }
      },
      leadingIcon: IconButton.filledTonal(
        onPressed: () {},
        icon: SvgPicture.asset(
          AppImages.icCameraDark,
          color: AppColors.white,
          width: 24,
          height: 24,
        ),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.blue60.withOpacity(0.6),
        ),
      ),
      suffixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<AudioBloc, AudioState>(
            builder: (context, audioState) {
              final isRecording = audioState is AudioRecording; // lấy từ state
              return GestureDetector(
                onTap: () async {
                  if (!isRecording) {
                    context.read<AudioBloc>().add(StartRecordEvent());
                  } else {
                    context.read<AudioBloc>().add(StopRecordEvent());
                  }
                },
                child: Icon(
                  size: 24,
                  isRecording ? Icons.stop : Icons.mic,
                  color: isRecording ? Colors.red : Colors.black,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          BlocBuilder<MediaPickedBloc, MediaPickedState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.black,
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (_) {
                      final height = MediaQuery.of(context).size.height;
                      return BlocProvider.value(
                        value: context.read<MediaPickedBloc>(),
                        child: SizedBox(
                          height: height * 0.75,
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              iconCloseBottomSheet(context),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 12,
                                ),
                                child: MediaHeaderOption(
                                  pageController: _pageController,
                                ),
                              ),
                              Expanded(
                                child: MediaGridView(
                                  onTap: () {
                                    if (state is MediaPickedSuccess &&
                                        state.selectedAsset != null) {
                                      print("Uplaod FIle Step 1");
                                      // context.read<ChatBloc>().add(
                                      //   UploadFileMessage(
                                      //     state.selectedAsset!,
                                      //     widget.conversation.conversationId,
                                      //   ),
                                      // );
                                      context.read<ChatBloc>().add(
                                        SendMessage(
                                          widget.conversation.conversationId,
                                          'Đã gửi 1 ảnh',
                                          files: state.selectedAsset,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: SvgPicture.asset(
                  AppImages.icPictureGallery,
                  width: 24,
                  height: 24,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              AppImages.icStickers,
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      onPressSuffixIcon: IconButton.filledTonal(
        onPressed: () {
          final text = _messageController.text.trim();
          if (text.isEmpty) return;
          context.read<ChatBloc>().add(
            SendMessage(widget.conversation.conversationId, text),
          );
          context.read<ChatBloc>().add(
            UserTypingOrStopTypingEvent(
              conversationId: widget.conversation.conversationId,
              isStop: true,
            ),
          );
          _messageController.clear();
          // sendChat();
        },

        icon: SvgPicture.asset(AppImages.icShare, color: AppColors.white),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.blue60.withOpacity(0.6),
        ),
      ),
      onPressPrefixIcon: IconButton.filledTonal(
        onPressed: () {},
        icon: SvgPicture.asset(AppImages.icSearch, color: AppColors.black),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildListUserOnline() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatSuccess && state.onlineUsers != null) {
          final names = state.onlineUsers!.map((u) => u.username).join(", ");
          return Text(
            names,
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // chỉ 1 dòng
            style: AppStyles.headlineRegular,
          );
        }
        return Text(
          '...',
          overflow: TextOverflow.ellipsis,
          maxLines: 1, // chỉ 1 dòng
          style: AppStyles.headlineRegular,
        );
      },
    );
  }

  Widget _buildStatusUserContact() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatSuccess) {
          return Text(
            state.statusUserContact.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // chỉ 1 dòng
            style: AppStyles.headlineRegular,
          );
        }
        return Text(
          '...',
          overflow: TextOverflow.ellipsis,
          maxLines: 1, // chỉ 1 dòng
          style: AppStyles.headlineRegular,
        );
      },
    );
  }

  Widget _itemMessage(MessageEntity msg) {
    final isMe = msg.senderId == widget.conversation.participants[0].id;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(formatDateTime(msg.createdAt.toString())),
        ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe
                ? const SizedBox()
                : groupUserAvatar(
                  avatarSize: 42,
                  images: [
                    msg.sender!.avatar ??
                        'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice',
                  ],
                ),
            const SizedBox(width: 8),
            (msg.attachments != null &&
                    msg.attachments!.isNotEmpty &&
                    msg.content == 'Đã gửi 1 ảnh')
                ? _itemFile(msg.attachments![0])
                : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          colors:
                              isMe
                                  ? [
                                    AppColors.purple100,
                                    AppColors.purple80,
                                    AppColors.purple60,
                                  ]
                                  : [AppColors.gray30, AppColors.gray40],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Text(
                        msg.content,
                        style: AppStyles.bodyRegular.copyWith(
                          color: isMe ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8, top: 2),
            child: Text(
              msg.isRead! ? 'Đã xem' : 'Đã gửi',
              style: AppStyles.footnoteRegular.copyWith(
                color: AppColors.gray70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemFile(Attachment attachment) {
    switch (attachment.fileType) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: '${ApiEndPoints.DOMAIN}${attachment.fileUrl}',
            width: 168,
            height: 256,
            color: AppColors.gray30,
            placeholder:
                (context, url) => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            errorWidget: (context, url, error) {
              print('Image load error: $error');
              return const Icon(Icons.broken_image, color: Colors.grey);
            },
            fit: BoxFit.cover,
          ),
        );
      default:
        // 🔹 Xử lý các file khác (pdf, video, ...)
        return Container(
          width: 168,
          height: 256,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: const Center(
            child: Icon(Icons.insert_drive_file, color: Colors.grey, size: 40),
          ),
        );
    }
  }
}
