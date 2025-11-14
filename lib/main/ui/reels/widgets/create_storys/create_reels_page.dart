import 'dart:io';

import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/reels/widgets/create_storys/bloc/create_reels_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/create_storys/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/widgets/create_storys/bloc/create_reels_state.dart';
import 'package:chat_app/main/ui/reels/widgets/create_storys/widgets/edit_element_media.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/widget/media_picked.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class CreateReelsPage extends StatefulWidget {
  CreateReelsPage({required this.listMediaPath, super.key});
  List<dynamic> listMediaPath;
  @override
  State<CreateReelsPage> createState() => _CreateReelsPageState();
}

class _CreateReelsPageState extends State<CreateReelsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final PageController _pageFilterController = PageController(
    initialPage: 0,
    viewportFraction: 0.25,
  );
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  CreateReelsBloc()..add(LoadReelsMedia(widget.listMediaPath)),
        ),
        BlocProvider(
          create:
              (_) =>
                  MediaPickedBloc()..add(
                    LoadRequest(requestType: RequestType.common, maxCount: 5),
                  ),
        ),
      ],
      child: BlocListener<CreateReelsBloc, CreateReelsState>(
        listener: (context, state) {
          if (state is CreateReelsSuccess && state.editedFile != null) {
            final data = ReelModel(
              assetList: [state.editedFile],
              media: MediaType.image,
              duration: Duration(seconds: 20),
            );
            context.pushNamed(PathName.listReelsPage, extra: [data]);
          }
        },
        child: BlocBuilder<CreateReelsBloc, CreateReelsState>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.black,
                body:
                    (state is CreateReelsSuccess)
                        ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                _buildMediaPlayer(context, state),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: _buildBottomTab(),
                                  ),
                                ),
                              ],
                            ),
                            // 🧩 Filter ra ngoài Stack player
                            if (state.isHideHeaderIcon)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 90, // đẩy ra ngoài player
                                child: _buildListFilterV1(context),
                              ),
                          ],
                        )
                        : (state is CreateReelsError)
                        ? Center(
                          child: Text(
                            state.message,
                            style: AppStyles.bodyBold.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        )
                        : Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMediaPlayer(BuildContext context, CreateReelsState state) {
    double height = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          SizedBox(
            height: height * 0.8,
            width: double.infinity,
            child:
                state is CreateReelsSuccess
                    ? state.asset != null
                        ? _imageMedia(height, context)
                        : _videoMedia(height, state.controller!)
                    : const Center(child: CircularProgressIndicator()),
          ),
          BlocBuilder<CreateReelsBloc, CreateReelsState>(
            buildWhen:
                (previous, current) =>
                    previous is CreateReelsSuccess &&
                    current is CreateReelsSuccess &&
                    previous.overlay != current.overlay,
            builder: (context, state) {
              if (state is CreateReelsSuccess && state.overlay != null) {
                final overlay = state.overlay!;
                if (overlay.content.isNotEmpty) {
                  final double screenHeight =
                      height * 0.8; // Chiều cao của player
                  final double screenWidth = MediaQuery.of(context).size.width;

                  return Positioned(
                    left: overlay.x * screenWidth,
                    top: overlay.y * screenHeight,
                    child: Transform.translate(
                      offset: const Offset(
                        -0.5,
                        -0.5,
                      ), // dịch ngược lại nửa đơn vị
                      child: FractionalTranslation(
                        translation: const Offset(
                          -0.5,
                          -0.5,
                        ), // căn giữa widget theo tâm
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            final newX =
                                (overlay.x * screenWidth + details.delta.dx) /
                                screenWidth;
                            final newY =
                                (overlay.y * screenHeight + details.delta.dy) /
                                screenHeight;

                            // Giới hạn trong khung hình
                            final clampedX = newX.clamp(0.0, 1.0);
                            final clampedY = newY.clamp(0.0, 1.0);

                            context.read<CreateReelsBloc>().add(
                              UpdateOverlayPosition(x: clampedX, y: clampedY),
                            );
                          },
                          child: _buildOverlayContent(context, overlay),
                        ),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox.shrink(); // Không có overlay hoặc nội dung rỗng
            },
          ),
          BlocBuilder<CreateReelsBloc, CreateReelsState>(
            builder: (context, state) {
              if (state is CreateReelsSuccess && state.sticker != null) {
                final overlay = state.overlay!;
                if (overlay.content.isNotEmpty) {
                  final double screenHeight =
                      height * 0.8; // Chiều cao của player
                  final double screenWidth = MediaQuery.of(context).size.width;

                  return Positioned(
                    left: overlay.x * screenWidth,
                    top: overlay.y * screenHeight,
                    child: Transform.translate(
                      offset: const Offset(
                        -0.5,
                        -0.5,
                      ), // dịch ngược lại nửa đơn vị
                      child: FractionalTranslation(
                        translation: const Offset(
                          -0.5,
                          -0.5,
                        ), // căn giữa widget theo tâm
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            final newX =
                                (overlay.x * screenWidth + details.delta.dx) /
                                screenWidth;
                            final newY =
                                (overlay.y * screenHeight + details.delta.dy) /
                                screenHeight;

                            // Giới hạn trong khung hình
                            final clampedX = newX.clamp(0.0, 1.0);
                            final clampedY = newY.clamp(0.0, 1.0);

                            context.read<CreateReelsBloc>().add(
                              UpdateOverlayPosition(x: clampedX, y: clampedY),
                            );
                          },
                          child: _buildOverlayContent(
                            context,
                            overlay,
                            isSticker: true,
                            asset: state.sticker,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox.shrink(); // Không có overlay hoặc nội dung rỗng
            },
          ),

          // Gradient phủ đen dưới
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),

          // Header icons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                (state is CreateReelsSuccess && state.isHideHeaderIcon)
                    ? Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          context.read<CreateReelsBloc>().add(
                            ToggleHeaderIcons(false),
                          );
                        },
                        child: const Text(
                          'Xong',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : Positioned(
                      left: 8,
                      right: 8,
                      top: 12,
                      child: _buildListHeaderIcon(context, height),
                    ),
          ),

          // Add Note
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child:
                (state is CreateReelsSuccess && state.isHideHeaderIcon)
                    ? const SizedBox.shrink()
                    : _buildAddNote(),
          ),
        ],
      ),
    );
  }

  Widget _imageMedia(double height, BuildContext context) {
    final currentState = context.watch<CreateReelsBloc>().state;
    int currentIndex = 0;

    if (currentState is CreateReelsSuccess) {
      currentIndex = currentState.currentIndex;
    }

    final colorFilter = getColorFilterByIndex(currentIndex);

    final imageWidget =
        (widget.listMediaPath.first is String)
            ? Image.file(
              File(widget.listMediaPath[0]),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
            )
            : AssetEntityImage(
              widget.listMediaPath.first,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(250),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            );

    return ColorFiltered(
      colorFilter:
          colorFilter ??
          const ColorFilter.mode(Colors.transparent, BlendMode.dst),
      child: imageWidget,
    );
  }

  Widget _videoMedia(double height, VideoPlayerController controller) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }

  Widget _buildListFilterV1(BuildContext ct) {
    final filters = [
      {'name': 'Normal', 'filter': null},
      {
        'name': 'Sepia',
        'filter': const ColorFilter.mode(Colors.brown, BlendMode.modulate),
      },
      {
        'name': 'BW',
        'filter': const ColorFilter.mode(Colors.grey, BlendMode.saturation),
      },
      {
        'name': 'Warm',
        'filter': const ColorFilter.mode(
          Colors.orangeAccent,
          BlendMode.overlay,
        ),
      },
      {
        'name': 'Cool',
        'filter': const ColorFilter.mode(Colors.blueAccent, BlendMode.overlay),
      },
    ];

    final currentState = ct.watch<CreateReelsBloc>().state;
    int selectedIndex = 0;

    if (currentState is CreateReelsSuccess) {
      selectedIndex = currentState.currentIndex;
    }

    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vòng tròn viền trắng ở giữa
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),

          // Danh sách filter dạng PageView
          PageView.builder(
            controller: _pageFilterController,
            itemCount: filters.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              ct.read<CreateReelsBloc>().add(
                ChangeFilterMedia(
                  index: index,
                  pageController: _pageFilterController,
                ),
              );
            },
            itemBuilder: (context, index) {
              final bool isSelected = selectedIndex == index;
              final colorFilter = filters[index]['filter'] as ColorFilter?;

              return GestureDetector(
                onTap: () {
                  // Nếu muốn chọn filter khi tap, thêm event riêng tại đây
                },
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 88 : 70,
                    height: isSelected ? 88 : 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                    ),
                    child: ClipOval(
                      child: ColorFiltered(
                        colorFilter:
                            colorFilter ??
                            const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.dst,
                            ),
                        child: Image.asset(
                          AppImages.imgAvatarDefault,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListHeaderIcon(BuildContext con, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset(
            AppImages.icChevronLeft,
            color: AppColors.white,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        Spacer(),
        BlocBuilder<CreateReelsBloc, CreateReelsState>(
          builder: (context, state) {
            return IconButton.filledTonal(
              onPressed: () {
                context.read<CreateReelsBloc>().add(
                  EditTextStory(MediaOverlay()),
                );
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(
                    0.5,
                  ), // nền đen trong suốt
                  builder: (dialogContext) {
                    return BlocProvider.value(
                      value:
                          context
                              .read<CreateReelsBloc>(), // ✅ lấy bloc hiện tại
                      child: const Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.zero, // full màn hình
                        child: EditElementMedia(),
                      ),
                    );
                  },
                );
              },
              icon: SvgPicture.asset(AppImages.icText, color: AppColors.white),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.gray100.withOpacity(0.6),
              ),
            );
          },
        ),

        BlocBuilder<MediaPickedBloc, MediaPickedState>(
          builder: (context, state) {
            final mediaPickedBloc = context.read<MediaPickedBloc>();

            return IconButton.filledTonal(
              onPressed: () {
                showModalBottomSheet(
                  context: context, // dùng context đang có MediaPickedBloc
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    // ✅ Dùng BlocProvider.value để truyền Bloc đang có vào bottom sheet
                    return BlocProvider.value(
                      value: mediaPickedBloc,
                      child: SizedBox(
                        height: height * 0.8,
                        child: MediaGridView(
                          onTap: () {
                            final state = mediaPickedBloc.state;
                            if (state is MediaPickedSuccess &&
                                state.selectedAsset?.isNotEmpty == true) {
                              context.read<CreateReelsBloc>().add(
                                AddMediaItem(
                                  'mediapath',
                                  state.selectedAsset!.first,
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              print(
                                '⚠️ Chưa có media hoặc state chưa cập nhật',
                              );
                            }
                          },
                          isHideListChooseMedia: true,
                        ),
                      ),
                    );
                  },
                );
              },
              icon: SvgPicture.asset(
                AppImages.icStickers,
                color: AppColors.white,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.gray100.withOpacity(0.6),
              ),
            );
          },
        ),

        IconButton.filledTonal(
          onPressed: () {
            con.read<CreateReelsBloc>().add(ToggleHeaderIcons(true));
          },
          icon: SvgPicture.asset(AppImages.icFilters, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icMusic, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icOption, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildAddNote() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          // isScrollControlled: true,
          backgroundColor: AppColors.gray80,
          builder:
              (context) => Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray80,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: _buildBottomSheetAddNote(),
              ),
        );
      },
      child: Text(
        'Thêm chú thích...',
        style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildBottomSheetAddNote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconCloseBottomSheet(context),
        Row(
          children: [
            CircleAvatar(
              child: Image.asset(
                AppImages.imgAvatarDefault,
                width: 48,
                height: 48,
              ),
            ),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: _textEditingController,
                style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
                onChanged: (_) {},
                decoration: InputDecoration(
                  hintText: 'Thêm chú thích...',
                  hintStyle: AppStyles.bodyRegular.copyWith(
                    color: AppColors.white,
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  fillColor: AppColors.gray20,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon:
                      _textEditingController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              print('Nội dung: ${_textEditingController.text}');
                              _textEditingController.clear();
                            },
                          )
                          : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gray70,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      AppImages.imgAvatarDefault,
                      width: 32,
                      height: 32,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tin của bạn',
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gray70,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icStartRoundWhite,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tin của bạn',
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<CreateReelsBloc, CreateReelsState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  if (state is CreateReelsSuccess && state.overlay != null) {
                    context.read<CreateReelsBloc>().add(
                      UploadReels(
                        'typeMedia',
                        'content',
                        'h',
                        overlay: state.overlay!,
                        indexFilter: state.currentIndex,
                        sticker: state.sticker,
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(AppImages.icChevronRight),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayContent(
    BuildContext context,
    MediaOverlay overlay, {
    bool isSticker = false,
    AssetEntity? asset,
  }) {
    return (isSticker && asset != null)
        ? AssetEntityImage(
          asset,
          isOriginal: false,
          thumbnailSize: const ThumbnailSize.square(250),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error, color: Colors.red));
          },
        )
        : Container(
          padding: overlay.hasBackground ? const EdgeInsets.all(8.0) : null,
          decoration:
              overlay.hasBackground
                  ? BoxDecoration(
                    color: overlay.color.withOpacity(
                      0.5,
                    ), // Ví dụ background mờ
                    borderRadius: BorderRadius.circular(8),
                  )
                  : null,
          child: Text(
            overlay.content,
            textAlign: overlay.textAlign,
            style: TextStyle(
              fontSize: overlay.size,
              color: overlay.color,
              fontFamily: overlay.fontText,
              // Có thể thêm FontWeight nếu cần
            ),
          ),
        );
  }
}

ColorFilter? getColorFilterByIndex(int index) {
  switch (index) {
    case 1:
      return const ColorFilter.mode(Colors.brown, BlendMode.modulate); // Sepia
    case 2:
      return const ColorFilter.mode(Colors.grey, BlendMode.saturation); // BW
    case 3:
      return const ColorFilter.mode(
        Colors.orangeAccent,
        BlendMode.overlay,
      ); // Warm
    case 4:
      return const ColorFilter.mode(
        Colors.blueAccent,
        BlendMode.overlay,
      ); // Cool
    default:
      return const ColorFilter.mode(
        Colors.transparent,
        BlendMode.dst,
      ); // Normal
  }
}
