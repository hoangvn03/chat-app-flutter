import 'dart:io';
import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/message/audio_chat/audio_item.dart';
import 'package:chat_app/main/ui/conversations/screens/message/audio_chat/bloc/audio_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/message/bloc/chat_state.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/widget/media_option_header.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/widget/media_picked.dart';
import 'package:chat_app/main/ui/widget/post/media_item.dart';
import 'package:chat_app/main/ui/widget/share_media/share_bottom_sheet.dart';
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
import 'package:photo_manager/photo_manager.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.conversation,
    required this.userContact,
  });

  final Conversation conversation;
  final UserModel userContact;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _messageController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _listImage => [
    widget.conversation.participants.firstOrNull?.avatar ??
        AppImages.icStickers,
    widget.conversation.participants.lastOrNull?.avatar ?? AppImages.icStickers,
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatBloc()..add(LoadMessage(widget.conversation)),
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
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          // Chỉ hiện dialog nếu có statusMessage và message đó khác rỗng
          if (state is ChatSuccess &&
              state.statusMessage != null &&
              state.statusMessage!.isNotEmpty) {
            showDialog(
              context: context,
              barrierDismissible: false, // Bắt buộc user bấm OK
              builder:
                  (dialogContext) => AlertDialog(
                    // Đổi tên biến context thành dialogContext để tránh nhầm
                    backgroundColor: Colors.white,
                    // ... (giữ nguyên code giao diện dialog của bạn) ...
                    content: Text(
                      state.statusMessage ?? 'Đã có lỗi xảy ra',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyRegular,
                    ),
                    actions: [
                      TextButton(
                        // ... style ...
                        onPressed: () {
                          // 1. Đóng Dialog
                          Navigator.pop(dialogContext);

                          // 2. Gửi sự kiện xóa lỗi để StatusMessage về null
                          // Dùng context (của ChatRoom) chứ không phải dialogContext
                          context.read<ChatBloc>().add(ClearAlertMessage());
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
          appBar: _buildAppBar(context),
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
                              widget.conversation.isGroup
                                  ? _buildInfoGroup(context)
                                  : _buildInfoUserContact(context),
                              const SizedBox(height: 64),
                              Text(
                                formatDateTimeV3(widget.conversation.createdAt),
                              ),
                              const SizedBox(height: 16),
                              _buildMessageList(state.messages),
                              _buildTypingIndicator(state.typingUsers ?? []),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: _buildBottomInput(context),
                    ),
                  ],
                );
              }
              return Center(
                child: Text(
                  'Đã có lỗi xảy ra: ${state is ChatFailure ? state.errorMessage : ""}',
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Widgets Breakdown ---

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      leading: IconButton(
        onPressed: () async {
          final user = await AppStorage.getUser();
          context.pushReplacementNamed(PathName.chatPage, extra: user);
        },
        icon: Transform.flip(
          flipX: true,
          child: SvgPicture.asset(AppImages.icNextRight),
        ),
      ),
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: groupUserAvatar(images: _listImage, avatarSize: 42),
        title: Text(
          widget.conversation.isGroup
              ? widget.conversation.conversationName ?? 'Unknown'
              : widget.userContact.username ?? 'Unknown',
          style: AppStyles.title2Bold,
        ),
        subtitle:
            widget.conversation.isGroup
                ? _buildListUserOnlineText()
                : _buildStatusUserContact(),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icSearch),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildListUserOnlineText() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatSuccess &&
            state.onlineUsers != null &&
            state.onlineUsers!.isNotEmpty) {
          final names = state.onlineUsers!.map((u) => u.username).join(", ");
          return Text(
            names,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppStyles.headlineRegular,
          );
        }
        return Text('...', style: AppStyles.headlineRegular);
      },
    );
  }

  Widget _buildStatusUserContact() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatSuccess) {
          return Text(
            state.statusUserContact.name,
            style: AppStyles.headlineRegular,
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildInfoUserContact(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.gray30),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.network(
            widget.userContact.avatar ?? AppImages.icStickers,
            width: 86,
            height: 86,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.userContact.username ?? 'Unknown',
          style: AppStyles.title2Bold,
        ),
        RichText(
          text: TextSpan(
            text: '1 người theo dõi . ',
            style: AppStyles.title3Regular.copyWith(color: AppColors.gray60),
            children: const [TextSpan(text: '1 bài viết')],
          ),
        ),
        const SizedBox(height: 16),
        IntrinsicWidth(
          child: commonButton(
            margin: EdgeInsets.zero,
            hasHeight: false,
            padding: const EdgeInsets.all(8),
            color: AppColors.gray20,
            textStyle: AppStyles.bodyBold,
            text: 'Xem trang cá nhân',
            onTap: () {
              context.pushNamed(
                PathName.profilePage,
                extra: widget.userContact,
              );
            },
            radius: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGroup(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        groupUserAvatar(images: _listImage, avatarSize: 86, overlap: 64),
        const SizedBox(height: 16),
        Text(
          widget.conversation.conversationName ?? 'Unknown',
          style: AppStyles.title2Bold,
        ),
        GestureDetector(
          onTap: () {
            context.pushNamed(
              PathName.editInfomationGroupPage,
              extra: {
                'chatBloc': context.read<ChatBloc>(),
                'audioBloc': context.read<AudioBloc>(),
                'mediaBloc': context.read<MediaPickedBloc>(),
                'conversation': widget.conversation,
              },
            );
          },
          child: Text(
            'Đổi tên và hình ảnh',
            style: AppStyles.title2Bold.copyWith(color: AppColors.blue60),
          ),
        ),
        const SizedBox(height: 16),
        _buildListIconHeaderGroup(),
      ],
    );
  }

  Widget _buildListIconHeaderGroup() {
    final items = [
      {'icon': AppImages.icLink, 'text': 'Liên kết mới'},
      {'icon': AppImages.icAddUser, 'text': 'Thêm người'},
      {'icon': AppImages.icShare, 'text': 'Chia sẻ'},
      {'icon': AppImages.icComment, 'text': 'Chủ đề'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          items
              .map(
                (e) => Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset(e['icon']!, width: 32, height: 32),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 68,
                        child: Text(
                          e['text']!,
                          style: AppStyles.bodyRegular,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildMessageList(List<MessageEntity> messages) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) => _itemMessage(messages[index]),
    );
  }

  Widget _itemMessage(MessageEntity msg) {
    bool isMe = msg.senderId != widget.userContact.id;
    if (widget.conversation.isGroup) {
      isMe = msg.senderId == widget.userContact.id;
    }
    String? contentMedia;
    final firstPart = msg.content.split("|")[0].trim();

    if (firstPart.isNotEmpty &&
        firstPart != "Đã gửi 1 ảnh" &&
        firstPart != "Đã gửi 1 video") {
      contentMedia = firstPart;
    }

    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(formatDateTime(msg.createdAt.toString())),
        ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              groupUserAvatar(
                avatarSize: 42,
                images: [
                  msg.sender?.avatar ??
                      'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice',
                ],
              ),
              const SizedBox(width: 8),
            ],

            // Content Check
            if (msg.attachments != null &&
                msg.attachments!.isNotEmpty &&
                (msg.content.contains('Đã gửi 1 ảnh') ||
                    msg.content.contains('Đã gửi 1 video')))
              Row(
                children: [
                  if (!isMe) ...[
                    _itemFile(msg.attachments![0], contentMedia),
                    const SizedBox(width: 8),
                  ],
                  IconButton.filledTonal(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        backgroundColor: AppColors.gray80,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return ShareBottomSheet(
                            mediaItem: attachmentsToMediaList(msg.attachments!),
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      AppImages.icShare,
                      color: AppColors.black,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.gray30,
                    ),
                  ),
                  const SizedBox(width: 8),
                  isMe
                      ? _itemFile(msg.attachments![0], contentMedia)
                      : const SizedBox.shrink(),
                ],
              )
            else if (msg.content == 'Đã gửi 1 đoạn giọng nói' &&
                msg.attachments != null &&
                msg.attachments!.isNotEmpty)
              _buildAudioMessage(msg.attachments![0])
            else
              _buildTextMessage(msg, isMe, width),
          ],
        ),
        if (isMe)
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

  Widget _buildAudioMessage(Attachment attachment) {
    final url = '${ApiEndPoints.DOMAIN}${attachment.fileUrl}';

    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return FutureBuilder<String>(
          future: context.read<AudioBloc>().getAudioDuration(url),
          builder: (context, snapshot) {
            return audio(
              message: url,
              index: 1,
              isCurrentUser: true,
              time: '',
              duration: snapshot.data ?? '00:00',
              isPlayVoiceMessage: true,
            );
          },
        );
      },
    );
  }

  Widget _buildTextMessage(MessageEntity msg, bool isMe, double width) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width * 0.6),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
    );
  }

  Widget _itemFile(Attachment attachment, String? contentMedia) {
    final media = Media(
      mediaType: attachment.fileType,
      mediaUrl: '${ApiEndPoints.DOMAIN}${attachment.fileUrl}',
    );

    Widget content;
    if (attachment.fileType == 'image' || attachment.fileType == 'video') {
      content = MediaItem(media: [media], radius: 12);
    } else {
      content = Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.insert_drive_file, color: Colors.amber, size: 40),
        ),
      );
    }

    return GestureDetector(
      onTap:
          () => showImageNetWork(
            context,
            imageUrl: '${ApiEndPoints.DOMAIN}${attachment.fileUrl}',
          ),
      child: Container(
        width: 168,
        height: 256,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Expanded(child: content),
              if (contentMedia != null)
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  color: AppColors.gray20,
                  child: Text(
                    contentMedia,
                    style: AppStyles.bodyRegular,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInput(BuildContext context) {
    return commonTextFieldV2(
      radius: 32,
      height: 56,
      margin: EdgeInsets.zero,
      controller: _messageController,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      onChanged: (value) {
        final chatBloc = context.read<ChatBloc>();
        chatBloc.add(
          UserTypingOrStopTypingEvent(
            conversationId: widget.conversation.conversationId,
            isStop: value.isEmpty,
          ),
        );
      },
      leadingIcon: IconButton.filledTonal(
        onPressed: () {},
        icon: SvgPicture.asset(AppImages.icCameraDark, color: AppColors.white),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.blue60.withOpacity(0.6),
        ),
      ),
      suffixIcon: _buildSuffixInput(context),
      onPressSuffixIcon: IconButton.filledTonal(
        onPressed: () => _handleSendMessage(context),
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

  Widget _buildSuffixInput(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, audioState) {
        // Logic Recording
        if (audioState is AudioRecording) {
          return GestureDetector(
            onTap: () => context.read<AudioBloc>().add(StopRecordEvent()),
            child: const Icon(Icons.stop, color: Colors.red, size: 24),
          );
        }
        // Logic Recorded Success
        if (audioState is AudioStateSuccess && !audioState.isPlayVoiceMessage) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              audio(
                message: audioState.currentUrl,
                isCurrentUser: true,
                index: 0,
                time: '00:00',
                duration: formatDuration(audioState.totalDuration),
                isPlayVoiceMessage: false,
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: () async {
                  final File audioFile = File(audioState.currentUrl);
                  if (await audioFile.exists()) {
                    if (!context.mounted) return;
                    context.read<ChatBloc>().add(
                      SendMessage(
                        widget.conversation.conversationId,
                        'Đã gửi 1 đoạn giọng nói',
                        files: [audioFile],
                      ),
                    );
                    context.read<AudioBloc>().add(ResetAudioEvent());
                  }
                },
                icon: SvgPicture.asset(
                  AppImages.icShare,
                  color: AppColors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.blue60.withOpacity(0.6),
                ),
              ),
            ],
          );
        }

        // Default: Mic + Gallery + Sticker
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => context.read<AudioBloc>().add(StartRecordEvent()),
              child: SvgPicture.asset(
                AppImages.icMic,
                width: 24,
                height: 24,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _showMediaPickerSheet(context),
              child: SvgPicture.asset(
                AppImages.icPictureGallery,
                width: 24,
                height: 24,
              ),
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
            const SizedBox(width: 12),
          ],
        );
      },
    );
  }

  void _handleSendMessage(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatBloc = context.read<ChatBloc>();
    chatBloc.add(SendMessage(widget.conversation.conversationId, text));
    chatBloc.add(
      UserTypingOrStopTypingEvent(
        conversationId: widget.conversation.conversationId,
        isStop: true,
      ),
    );
    _messageController.clear();
  }

  void _showMediaPickerSheet(BuildContext context) {
    final mediaPickedBloc = context.read<MediaPickedBloc>();
    mediaPickedBloc.add(ResetMediaPicked());

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: mediaPickedBloc,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                const SizedBox(height: 12),
                iconCloseBottomSheet(context),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MediaHeaderOption(pageController: _pageController),
                ),
                Expanded(
                  child: MediaGridView(
                    isHideListChooseMedia: true,
                    onTap: () {
                      final state = mediaPickedBloc.state;
                      if (state is MediaPickedSuccess &&
                          state.selectedAsset != null &&
                          state.selectedAsset!.isNotEmpty) {
                        final asset = state.selectedAsset![0];
                        final msgContent =
                            asset.type == AssetType.video
                                ? 'Đã gửi 1 video'
                                : 'Đã gửi 1 ảnh';

                        context.read<ChatBloc>().add(
                          SendMessage(
                            widget.conversation.conversationId,
                            msgContent,
                            mediaFiles: state.selectedAsset,
                          ),
                        );
                      }
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator(List<UserModel> users) {
    if (users.isEmpty) return const SizedBox();

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
        children: [
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Lỗi"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }
}

List<Media> attachmentsToMediaList(List<Attachment> attachments) {
  return attachments.map((att) => attachmentToMedia(att)).toList();
}

Media attachmentToMedia(Attachment attachment) {
  return Media(
    mediaId: attachment.attachmentId,
    mediaUrl: "${ApiEndPoints.DOMAIN}${attachment.fileUrl}",
    mediaType: attachment.fileType,
    orderIndex: 0, // nếu cần có thứ tự, có thể truyền vào
  );
}
