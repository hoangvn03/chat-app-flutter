import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/ui/widget/post/widgets/bloc/interaction_cubit.dart';
import 'package:chat_app/main/ui/widget/post/widgets/interaction_button.dart';
import 'package:chat_app/main/ui/widget/post/bloc/action_bloc.dart';
import 'package:chat_app/main/ui/widget/post/bloc/action_event.dart';
import 'package:chat_app/main/ui/widget/post/bloc/action_state.dart';
import 'package:chat_app/main/networks/model/comment.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentWidget extends StatefulWidget {
  final TextEditingController textController;
  final int postId;
  final PostModel postModel;

  const CommentWidget({
    super.key,
    required this.textController,
    required this.postId,
    required this.postModel
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final ScrollController _scrollController = ScrollController();

  // ✅ Thêm biến để biết đang reply comment nào
  int? _replyToCommentId;
  String? _replyToUsername;
  late ActionBloc actionBloc;
  @override
  void initState() {
    actionBloc = context.read<ActionBloc>();
    actionBloc.add(LoadComment(post: widget.postModel));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionBloc, ActionState>(
      builder: (context, state) {
        if (state is ActionSuccess) {
          // Auto scroll xuống cuối khi có comment mới
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            }
          });
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        const SizedBox(height: 16),
                        Text('Bình luận', style: AppStyles.title2Bold),
                        const SizedBox(height: 16),
                        // Danh sách bình luận
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            if (comment.commenter != null) {
                              print(comment.commenter!.avatar);
                            } else {
                              print('Null r');
                            }
                            return _commentItem(comment, context);
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BOTTOM INPUT
            bottomSheet: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColors.white),
              child: Row(
                children: [
                  ClipOval(
                    child: SvgPicture.network(
                      'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice',
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                      placeholderBuilder:
                          (context) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // TextField
                  Expanded(
                    child: commonTextFieldV2(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      controller: widget.textController,
                      hintText:
                          _replyToUsername != null
                              ? 'Trả lời $_replyToUsername...'
                              : 'Nhập bình luận...',
                      radius: 32,
                      height: 42,
                      enabled: true,
                      hasLeading: false,
                      color: AppColors.white,
                      border: Border.all(width: 1, color: AppColors.gray30),
                      onPressSuffixIcon: GestureDetector(
                        onTap: () {
                          final text = widget.textController.text.trim();
                          if (text.isEmpty) return;

                          if (_replyToCommentId != null) {
                            // 🟢 Nếu đang ở chế độ reply
                            context.read<ActionBloc>().add(
                              PostCommnetReply(
                                content: text,
                                commentId: _replyToCommentId!,
                                postId: widget.postId,
                                userTag: _replyToUsername ?? '',
                              ),
                            );
                          } else {
                            // 🟡 Nếu là comment thường
                            context.read<ActionBloc>().add(
                              PostCommnet(content: text, postId: widget.postId),
                            );
                          }
                          setState(() {
                            _replyToCommentId = null;
                            _replyToUsername = null;
                          });
                          widget.textController.clear();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: AppColors.blue60.withOpacity(0.6),
                          ),
                          child: SvgPicture.asset(
                            AppImages.icShare,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// Hiển thị từng comment (bao gồm cả comment con)
  Widget _commentItem(
    CommentModel item,
    BuildContext context, {
    bool isRoot = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ClipOval(
                child: SvgPicture.network(
                  item.commenter!.avatar ?? '',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  placeholderBuilder:
                      (context) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                ),
              ),
              const SizedBox(width: 8),

              // Nội dung
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppStyles.bodyRegular.copyWith(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: item.commenter!.username ?? 'Unknown',
                            style: AppStyles.bodyBold.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                " ${item.createdAt?.hour.toString().padLeft(2, '0')}:${item.createdAt?.minute.toString().padLeft(2, '0')}",
                            style: AppStyles.bodyRegular.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item.content ?? '', style: AppStyles.bodyRegular),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // 🟢 Khi bấm "Trả lời"
                        setState(() {
                          _replyToCommentId = item.commentId;
                          _replyToUsername =
                              item.commenter!.username ?? 'Unknown';
                        });

                        // Hiển thị tên trong TextField
                        widget.textController.text = '@${_replyToUsername!} ';
                        widget
                            .textController
                            .selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: widget.textController.text.length,
                          ),
                        );
                      },
                      child: Text(
                        'Trả lời',
                        style: AppStyles.footnoteRegular.copyWith(
                          color: AppColors.blue60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Hiển thị comment con
          if (item.children != null && item.children!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: item.parentCommentId != null ? 0 : 48,
              ),
              child: Column(
                children:
                    item.children!
                        .map(
                          (child) => Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: _commentItem(child, context, isRoot: false),
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

Widget sharePageBottomSheet() {
  return Container();
}

Widget savePageBottomSheet() {
  return Container();
}
