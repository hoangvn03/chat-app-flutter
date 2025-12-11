import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/widgets/edit_post_media_page.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/widget/media_option_header.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/widget/media_picked.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});
  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        context.goNamed(PathName.personalPage);
        return false;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) =>
                    MediaPickedBloc()..add(
                      LoadRequest(requestType: RequestType.common, maxCount: 5),
                    ),
          ),
          BlocProvider(create: (_) => HomeBloc()),
        ],
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              BlocBuilder<MediaPickedBloc, MediaPickedState>(
                builder: (context, state) {
                  if (state is MediaPickedSuccess) {
                    if (state.asset.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final AssetEntity selectedAsset =
                        (state.selectedAsset != null &&
                                state.selectedAsset!.isNotEmpty)
                            ? state.selectedAsset!.last
                            : state.asset.first;
                    return _buildMediaPost(selectedAsset);
                  }

                  // Nếu chưa load xong → hiển thị loading
                  return Container(color: AppColors.black);
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed:
                              () => context.goNamed(PathName.personalPage),
                          icon: Transform.flip(
                            flipX: true,
                            child: SvgPicture.asset(
                              AppImages.icClose,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        BlocBuilder<MediaPickedBloc, MediaPickedState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () async {
                                if (state is MediaPickedSuccess) {
                                  final listFile = await convertAssetEntitiesToFiles(
                                    state.selectedAsset!,
                                  );
                                  state.selectedAsset![0].type ==
                                          AssetType.video
                                      ? context.pushNamed(
                                        PathName.editVideoPage,
                                        extra: listFile[0].path,
                                      )
                                      : context.pushNamed(
                                        PathName.imageEditorScreen,
                                        extra: [
                                          state.selectedAsset,
                                          BlocProvider.of<HomeBloc>(context),
                                        ],
                                      );
                                }
                              },
                              child: Text(
                                'Tiếp',
                                style: AppStyles.title1Bold.copyWith(
                                  color: AppColors.blue60,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  // MediaGridView
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: AppColors.black,
                      height: height * 0.5,
                      child: MediaGridView(isHideListChooseMedia: true),
                    ),
                  ),
                  // MediaHeaderOption - có thể điều chỉnh vị trí
                  Positioned(
                    bottom: height * 0.5, // Cách MediaGridView 10px
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      color: AppColors.black,
                      child: MediaHeaderOption(pageController: _pageController),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //đây là list ảnh
        ),
      ),
    );
  }

  //đây là hiển thị ảnh được chọn
  Widget _buildMediaPost(AssetEntity asset) {
    return Positioned.fill(
      child: AssetEntityImage(
        asset,
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(250),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        },
      ),
    );
  }
}
