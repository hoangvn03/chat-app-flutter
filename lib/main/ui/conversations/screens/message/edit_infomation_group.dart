import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditInfomationGroup extends StatelessWidget {
  EditInfomationGroup({super.key, required this.conversation})
    : _groupNameController = TextEditingController(
        text: conversation.conversationName ?? '',
      );

  final Conversation conversation;
  final TextEditingController _groupNameController;

  @override
  Widget build(BuildContext context) {
    var listImage = [
      conversation.participants[0].avatar ?? AppImages.icStickers,
      conversation.participants[1].avatar ?? AppImages.icStickers,
    ];

    if (!conversation.isGroup) {
      listImage = [conversation.participants[1].avatar ?? AppImages.icStickers];
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: GestureDetector(
          onTap: () => context.pop(),
          child: Text('Hủy', style: AppStyles.title2Regular),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false, // Bắt buộc user bấm OK
                builder: (dialogContext) {
                  return resultDialog(
                    context: context,
                    message: "Chức năng đang được phát triển",
                    title: "Error",
                    urlImage: AppImages.icWarning,
                    isHideExit: true,
                    onTap: () => context.pop(),
                    isSuccess: false,
                  );
                },
              );
              debugPrint('Tên nhóm mới: ${_groupNameController.text}');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Xong', style: AppStyles.title2Regular),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            groupUserAvatar(
              images: listImage,
              avatarSize: conversation.isGroup ? 86 : 86,
              overlap: 64,
            ),
            const SizedBox(height: 16),
            commonTextFieldV2(
              hintText: 'Tên nhóm',
              controller: _groupNameController,
              color: AppColors.white,
              border: Border.all(width: 1, color: AppColors.gray30),
              hasHeight: false,
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
              hasLeading: false,
            ),
          ],
        ),
      ),
    );
  }
}
