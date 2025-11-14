import 'package:camera/camera.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/reels/widgets/camera/bloc/camera_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/camera/bloc/camera_event.dart';
import 'package:chat_app/main/ui/reels/widgets/camera/bloc/camera_state.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app/main.dart' show cameras;
import 'package:go_router/go_router.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CameraController _cameraController;
  final PageController _pageFilterController = PageController(
    initialPage: 0,
    viewportFraction: 0.25,
  );

  @override
  void initState() {
    super.initState();
    initCamera();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageFilterController.dispose();
    super.dispose();
  }

  initCamera() {
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (!_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: BlocProvider(
        create: (_) => CameraBloc(),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocListener<CameraBloc, CameraState>(
            listener: (context, state) {
              // Xử lý khi chụp ảnh thành công
              if (state is TakeMediaSuccess) {
                context.pushNamed(
                  PathName.createReelsPage,
                  extra: [state.imagePath],
                );
              }
            },
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: height * 0.8,
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 8,
                    right: 8,
                    child: _buildListHeaderIcon(),
                  ),
                  Positioned(
                    left: 12,
                    bottom: height * 0.5,
                    child: _buildListLeftIcon(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: _buildListFilterV1(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListHeaderIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset(AppImages.icClose, color: AppColors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.flash_on, color: AppColors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icOption, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildListLeftIcon() {
    return Column(
      children: [
        IconButton(
          onPressed: () => debugPrint('P1'),
          icon: SvgPicture.asset(AppImages.icText, color: AppColors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icInfinity, color: AppColors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icLayout, color: AppColors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: Transform.rotate(
            angle: 3.1416,
            child: SvgPicture.asset(
              AppImages.icChevronUp,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  int selectedIndex = 0;

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

    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        return SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),

              PageView.builder(
                controller: _pageFilterController,
                itemCount: filters.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  selectedIndex = index;
                  context.read<CameraBloc>().add(
                    ChangeFilterPage(
                      index: index,
                      pageController: _pageFilterController,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      context.read<CameraBloc>().add(
                        TakePicture(cameraController: _cameraController),
                      );
                    },
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 88 : 70,
                        height: isSelected ? 88 : 70,
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.imgAvatarDefault,
                            fit: BoxFit.cover,
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
      },
    );
  }

  Widget _buildTabBar() {
    return Material(
      color: Colors.black.withOpacity(0.4),
      child: SafeArea(
        top: false,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Tin'),
            Tab(text: 'Bài viết'),
            Tab(text: 'Thước phim'),
          ],
          onTap: (index) {
            debugPrint('Chuyển sang tab $index');
          },
        ),
      ),
    );
  }
}
