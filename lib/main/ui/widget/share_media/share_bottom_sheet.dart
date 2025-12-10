import 'dart:io';

import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_bloc.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_event.dart';
import 'package:chat_app/main/ui/conversations/bloc/conversations_state.dart';
import 'package:chat_app/main/ui/widget/post/media_item.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ShareBottomSheet extends StatelessWidget {
  ShareBottomSheet({super.key, required this.mediaItem});
  final List<Media> mediaItem;
  final TextEditingController _shareController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Màu nền tối (Dark Theme)
    final searchBarColor = const Color(0xFF363636);

    return BlocProvider(
      create: (_) => ConversationsBloc()..add(LoadRequest()),
      child: BlocListener<ConversationsBloc, ConversationsState>(
        listener: (context, state) {
          if (state is ConversationsSuccess && state.message != null) {
            _showToastOverlay(context, state.message!);
            context.pop();
          }
        },
        child: BlocBuilder<ConversationsBloc, ConversationsState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.gray80,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Để sheet co giãn theo nội dung
                children: [
                  // 1. Thanh kéo (Handle bar)
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.only(top: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.gray30,
                        ),
                        height: 4,
                        width: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Thanh tìm kiếm và Icon thêm người
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: searchBarColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[400],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: searchBarColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_add_outlined,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  (state is ConversationsSuccess && state.data != null)
                      ?
                      // 3. Grid danh sách người dùng (User Grid)
                      SizedBox(
                        height: 230,
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount:
                              state
                                  .data!
                                  .conversations
                                  .length, // Số lượng phần tử trong danh sách
                          // Cấu hình lưới (số cột, khoảng cách)
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // 4 người 1 hàng
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.75, // Tỷ lệ khung hình
                              ),
                          // Hàm xây dựng từng item
                          itemBuilder: (context, index) {
                            final selectedId = state.selectedConversationId;

                            List<Conversation> converation =
                                state.data!.conversations;
                            return _buildUserItem(
                              converation[index],
                              state.userModel!,
                              context,
                              converation[index].conversationId == selectedId,
                            );
                          },
                        ),
                      )
                      : const Center(child: CircularProgressIndicator()),
                  const Divider(color: Colors.grey, thickness: 0.2),
                  const SizedBox(height: 10),
                  _buildShareTextField(),
                  // 4. Hàng nút chức năng bên dưới (Action Row)
                  //   SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         _buildActionButton(
                  //           icon: Icons.add_circle_outline,
                  //           label: "Thêm vào\ntin",
                  //           color: Colors.grey[800]!,
                  //         ),
                  //         const SizedBox(width: 20),
                  //         _buildActionButton(
                  //           icon: Icons.chat_bubble,
                  //           label: "WhatsApp",
                  //           color: const Color(0xFF25D366),
                  //           iconColor: Colors.white,
                  //         ),
                  //         const SizedBox(width: 20),
                  //         _buildActionButton(
                  //           icon: Icons.timelapse,
                  //           label: "Trạng thái\nWhatsApp",
                  //           color: const Color(0xFF25D366),
                  //           iconColor: Colors.white,
                  //         ),
                  //         const SizedBox(width: 20),
                  //         _buildActionButton(
                  //           icon: Icons.share_outlined,
                  //           label: "Chia sẻ",
                  //           color: Colors.grey[800]!,
                  //         ),
                  //         const SizedBox(width: 20),
                  //         _buildActionButton(
                  //           icon: Icons.link,
                  //           label: "Sao chép\nliên kết",
                  //           color: Colors.grey[800]!,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  OverlayEntry? _toastEntry;

  void _showToastOverlay(BuildContext context, String message) {
    // Nếu đang có toast thì remove trước
    _toastEntry?.remove();

    _toastEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
    );

    // Insert vào overlay
    Overlay.of(context).insert(_toastEntry!);

    // Tự động ẩn sau 2 giây
    Future.delayed(const Duration(seconds: 2), () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }

  // Widget con: Hiển thị từng người dùng
  Widget _buildUserItem(
    Conversation conversation,
    UserModel user,
    BuildContext con,
    bool isSelected,
  ) {
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
      if (item.id != user.id) {
        userContact = item;
        break;
      }
    }
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ConversationsBloc>(
          con,
        ).add(ChooseConveration(conversation.conversationId));
      },
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar
              groupUserAvatar(
                images:
                    conversation.isGroup
                        ? listImage
                        : [userContact.avatar ?? AppImages.icStickers],
                avatarSize: conversation.isGroup ? 48 : 64,
              ),

              // Tick khi được chọn
              if (isSelected)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            conversation.isGroup
                ? (conversation.conversationName ?? 'Unknown')
                : (userContact.username ?? 'Unknown'),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget con: Nút chức năng tròn bên dưới
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    Color iconColor = Colors.white,
  }) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildShareTextField() {
    return BlocBuilder<ConversationsBloc, ConversationsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _shareController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Soạn tin nhắn...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            commonButton(
              text: 'Gửi',
              onTap: () {
                if (state is! ConversationsSuccess) {
                  print("State không hợp lệ");
                  return;
                } else if (state.selectedConversationId != null) {
                  context.read<ConversationsBloc>().add(
                    SendMessage(
                      state.selectedConversationId!,
                      _shareController.text,
                      mediaItem.map((e) => e.mediaUrl!).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuccessToast() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Gửi thành công",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
