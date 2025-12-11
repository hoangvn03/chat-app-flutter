import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/auth/bloc/auth_bloc.dart';
import 'package:chat_app/main/ui/auth/bloc/auth_event.dart';
import 'package:chat_app/main/ui/auth/bloc/auth_state.dart';
import 'package:chat_app/main/ui/profile/widgets/settings/bloc/settings_bloc.dart';
import 'package:chat_app/main/ui/profile/widgets/settings/bloc/settings_event.dart';
import 'package:chat_app/main/ui/profile/widgets/settings/bloc/settings_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingBloc()..add(LoadRequest())),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: Text("Cài đặt và hoạt động", style: AppStyles.title1Bold),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess && state.message != null) {
              context.goNamed(PathName.loginPage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message ?? 'Error',
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.erroMessage,
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state is SettingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SettingSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTextFieldV2(
                        margin: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        controller: searchController,
                        hintText: 'Tìm kiếm...',
                        enabled: true,
                      ),
                      _buildLicenceMeta(context),
                      _buildHowToUseApp(),
                      _buildAuthAction(),
                    ],
                  ),
                );
              } else if (state is SettingFailure) {
                return const Center(child: Text('Failed to load users'));
              }
              return const Center(child: Text('Welcome to the Chat Page!'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionAccount({
    bool isHideActionHeader = false,
    bool isHideBox = false,
    required String headerText,
    required Widget listItem,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isHideBox)
          Container(width: double.infinity, height: 8, color: AppColors.gray20),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerText,
                    style: AppStyles.title2Bold.copyWith(
                      color: AppColors.gray40,
                    ),
                  ),
                  if (isHideActionHeader) iconMeta(),
                ],
              ),
              const SizedBox(height: 24),
              listItem,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLicenceMeta(BuildContext context) {
    return _buildFunctionAccount(
      headerText: 'Tài khoản của bạn',
      isHideActionHeader: true,
      isHideBox: true,
      listItem: Column(
        children: [
          commonTileItemV2(
            title: 'Trung tâm tài khoản',
            subtitle:
                'Mật khẩu, bảo mật , thông tin cá nhân, tùy chọn quảng cáo',
            leadingWidget: SvgPicture.asset(AppImages.icPersonal),
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text:
                  'Quản lý phần cài đặt tài khoản và trar nghiệm kết nối trên các công nghệ của meta. ',
              style: AppStyles.headlineRegular.copyWith(
                color: AppColors.gray40,
              ),

              children: [
                TextSpan(
                  text: 'Tìm hiểu thêm',
                  style: AppStyles.headlineRegular.copyWith(
                    color: AppColors.blue80,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
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
                          print('Người dùng đã bấm Tìm hiểu thêm');
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseApp() {
    return _buildFunctionAccount(
      headerText: 'Cách bạn dùng Instargram',
      listItem: Column(
        children: [
          commonTileItemV2(
            title: 'Đã lưu',
            leadingWidget: SvgPicture.asset(AppImages.icSave),
          ),
          const SizedBox(height: 24),
          commonTileItemV2(
            title: 'Kho lưu trữ',
            leadingWidget: SvgPicture.asset(AppImages.icAddHighlight),
          ),
          const SizedBox(height: 24),
          commonTileItemV2(
            title: 'Hoạt động của bạn',
            leadingWidget: SvgPicture.asset(AppImages.icPictureGallery),
          ),
          const SizedBox(height: 24),
          commonTileItemV2(
            title: 'Thông báo',
            leadingWidget: SvgPicture.asset(AppImages.icNotificationsOff),
          ),
          const SizedBox(height: 24),
          commonTileItemV2(
            title: 'Quản lý thời gian',
            leadingWidget: SvgPicture.asset(AppImages.icStarRound),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthAction() {
    // Bỏ tham số parentContext
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return _buildFunctionAccount(
          headerText: 'Đăng nhập',
          listItem: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                },
                child: Text(
                  'Thêm tài khoản',
                  style: AppStyles.title2Regular.copyWith(
                    color: AppColors.blue80,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context, // Sử dụng context từ builder
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Đăng xuất khỏi tài khoản của bạn?',
                                textAlign: TextAlign.center,
                                style: AppStyles.title1Bold.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(height: 1, color: AppColors.gray20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                context.read<AuthBloc>().add(Logout());
                              },
                              child: Text(
                                'Đăng xuất',
                                style: AppStyles.title2Bold.copyWith(
                                  color: AppColors.red100,
                                ),
                              ),
                            ),
                            Container(height: 1, color: AppColors.gray20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  dialogContext,
                                ).pop(); // Đóng dialog
                              },
                              child: Text(
                                'Hủy',
                                style: AppStyles.title2Regular.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'Đăng xuất',
                  style: AppStyles.title2Regular.copyWith(
                    color: AppColors.red100,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                },
                child: Text(
                  'Đăng xuất khỏi thiết bị',
                  style: AppStyles.title2Regular.copyWith(
                    color: AppColors.red100,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
