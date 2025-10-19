
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_bloc.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_event.dart';
import 'package:chat_app/main/ui/chat/bloc/chat_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  ChatRoom({super.key, required this.conversationId, required this.sender});
  final int conversationId;
  final LastMessage sender;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  IO.Socket? socket;
  List<LastMessage> chats = [];

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() async {
    final token = await AppStorage.getToken();
    
    socket = IO.io(
      ApiEndPoints.DOMAININIT,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({
            'Authorization': 'Bearer $token',
          })
          .build(),
    );
    
    setUpListeners();
    socket!.connect();
  }

  void setUpListeners() {
    socket?.on('connect', (_) {
      Logger().i('connected');
      // Join conversation room
      socket?.emit('join_conversation', {
        'conversation_id': widget.conversationId,
      });
    });
    
    socket?.on('disconnect', (_) => Logger().e('disconnected'));
    socket?.on('connect_error', (error) => Logger().e('Connect error: $error'));
    
    // Lắng nghe tin nhắn mới
    socket?.on('new_message', (data) {
      final messageData = data['message'];
      setState(() {
        chats = [LastMessage.fromJson(messageData), ...chats];
      });
    });
    
    socket?.on('joined_conversation', (data) {
      Logger().i('Successfully joined conversation');
    });
    
    socket?.on('error', (error) {
      Logger().e('Socket error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Socket error: ${error['message']}')),
      );
    });
  }

  void sendChat() {
    if (_messageController.text.isNotEmpty) {
      // Gửi qua socket
      socket?.emit('send_message', {
        'conversation_id': widget.conversationId,
        'content': _messageController.text.trim(),
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ChatBloc()..add(LoadDetailConveration(widget.conversationId)),
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
                widget.sender.sender.username ?? 'Unkonwn',
                style: AppStyles.title2Bold,
              ),
              subtitle: Text(
                widget.sender.sender.status ?? 'Offline',
                style: AppStyles.headlineRegular,
              ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 38),
                            _buildInfoUserContact(),
                            const SizedBox(height: 58),
                            BlocSelector<
                              ChatBloc,
                              ChatState,
                              List<MessageModel>
                            >(
                              selector: (state) {
                                if (state is ChatSuccess)
                                  return state.message?.messages ?? [];
                                return [];
                              },
                              builder: (context, messages) {
                                return _buildListMessage(messages);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
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
          widget.sender.sender.username ?? 'Unkonwn',
          style: AppStyles.title2Bold,
        ),
        // Text(data.content, style: AppStyles.title3Regular),
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
                extra: UserModel(
                  username: 'hieu_pham',
                  avatar: AppImages.imgAvatarDefault,
                ),
              );
            },
            radius: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildListMessage(List<MessageModel> messages) {
    print('${messages.length}');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isMe = msg.senderId == widget.sender.sender.id;

        return Align(
          alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? AppColors.gray20 : AppColors.gray10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  msg.sender!.username ?? 'Unknown',
                  style: AppStyles.bodyBold.copyWith(
                    color: AppColors.gray70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg.content, style: AppStyles.bodyRegular),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFieldMessage(BuildContext context) {
    return commonTextFieldV2(
      radius: 32,
      height: 56,
      margin: EdgeInsets.zero,
      controller: _messageController,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      leadingIcon: IconButton.filledTonal(
        onPressed: () {},
        icon: SvgPicture.asset(AppImages.icCamera, color: AppColors.white),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.blue60.withOpacity(0.6),
        ),
      ),
      suffixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AppImages.icPictureGallery),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AppImages.icStickers),
          ),
        ],
      ),
      onPressSuffixIcon: IconButton.filledTonal(
        onPressed: () {
          final text = _messageController.text.trim();
          if (text.isEmpty) return;
          context.read<ChatBloc>().add(
            SendMessage(widget.conversationId, text),
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
}
