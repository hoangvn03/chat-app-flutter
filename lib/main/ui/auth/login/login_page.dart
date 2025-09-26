import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/auth/login/bloc/login_bloc.dart';
import 'package:chat_app/main/ui/auth/login/bloc/login_event.dart';
import 'package:chat_app/main/ui/auth/login/bloc/login_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_fonts.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.17, 0.36, 0.63, 0.83],
                  colors: [
                    Color(0xFF7638FA), // tím
                    Color(0xFFD300C5), // hồng tím
                    Color(0xFFFF7A00), // cam
                    Color(0xFFFFD600), // vàng
                    Color(0xFFFF0069), // hồng đậm
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: height * 0.10,
              child: SvgPicture.asset(
                AppImages.icLogoAppV2,
                width: 58,
                height: 58,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: EdgeInsets.only(top: height * 0.25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),

                children: [_buildCurrientAccount(), _buildLogin()],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: _buildCreateNewAccount(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrientAccount() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 24),
          child: IconButton(
            icon: SvgPicture.asset(AppImages.icOption, width: 32, height: 32),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _buildBottomSheetDeleteAccount(context),
              );
            },
          ),
        ),
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.gray30, // màu nền
          child: Image.asset(
            AppImages.imgAvatarDefault, // đường dẫn svg
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        const Text("hoang_vn03", style: AppStyles.title1Bold),
        commonButton(
          text: "Tiếp tục",
          color: AppColors.blue60,
          margin: EdgeInsets.symmetric(vertical: 16),
          onTap: () {
            context.go(AppPath.homePage);
          },
        ),
        InkWell(
          onTap: () {
            _pageController.animateToPage(
              1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: const Text(
            "Dùng trang cá nhân khác",
            style: AppStyles.title3Regular,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateNewAccount() {
    return Column(
      children: [
        commonButton(
          text: "Tạo tài khoản mới",
          color: AppColors.white,
          textColor: AppColors.blue60,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => _buildBottomSheetCreateAccount(context),
            );
          },
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.icMetaPng, width: 28, height: 18),
            const SizedBox(width: 4),
            Text("Meta", style: AppStyles.title3Bold),
          ],
        ),
      ],
    );
  }

  Widget _buildLogin() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 24),
          child: IconButton(
            icon: Transform.flip(
              flipX: true,
              child: SvgPicture.asset(AppImages.icNextRight),
            ),
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent, // 👈 để dễ custom border radius
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder:
                  (context) => _buildBottomSheetLanguage(context, [
                    "Tiếng Viêt",
                    "Tiếng Anh",
                  ]),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tiếng Việt", style: AppStyles.title3Regular),
              const SizedBox(width: 4),
              Transform.flip(
                flipY: true,
                child: SvgPicture.asset(AppImages.icChevronUp),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.go(AppPath.homePage);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('state.message')));
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonTextField(
                    labelText: "Tên người dùng,email/số di động",
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 16),
                  commonTextField(
                    labelText: "Mật khẩu",
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  commonButton(
                    text: "Đăng nhập",
                    margin: EdgeInsets.symmetric(vertical: 16),
                    onTap: () {
                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      context.read<LoginBloc>().add(Login(username, password));
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder:
                            (context) =>
                                _buildBottomSheetForgotPassword(context),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Quên mật khẩu?"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheetDeleteAccount(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: EdgeInsets.only(top: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.gray30,
              ),
              height: 4,
              width: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: SvgPicture.asset(AppImages.icClose),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("Trang cá nhân", style: AppStyles.title1Bold),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              context.pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _buildBottomSheetCreateAccount(context),
              );
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                "Gỡ trang cá nhân khỏi thiết bị này",
                style: AppStyles.title3Regular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetCreateAccount(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: EdgeInsets.only(top: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.gray30,
              ),
              height: 4,
              width: 32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(AppImages.icNextRight),
                    ),
                    onTap: () {
                      context.pop();
                    },
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Gỡ trang cá nhân khỏi thiết bị này",
              style: AppStyles.title3Regular,
            ),
          ),
          const SizedBox(width: 32),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 24),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: AppColors.gray30, width: 1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 38,
                  child: Image.asset(
                    AppImages.imgAvatarDefault,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Text('hoangvn03', style: AppStyles.title3Bold),
                const Spacer(), // đẩy Container ra cuối hàng
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.all(color: AppColors.gray30, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: InkWell(
                    child: Text('Gỡ/Xóa', style: AppStyles.title3Regular),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Tìm hiểu thêm ',
                  style: AppStyles.title3Bold.copyWith(color: AppColors.blue60),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          print('Tap ');
                        }, // hàm khi click
                ),
                TextSpan(
                  text:
                      'về lý do bạn nhìn thấy các trang cá nhân ở đây và ý nghĩa của việc gỡ các trang cá nhân.',
                  style: AppStyles.title3Regular.copyWith(
                    color: AppColors.gray40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetForgotPassword(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              child: Container(
                margin: EdgeInsets.only(top: 7),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(AppImages.icNextRight),
                    ),
                    onTap: () {
                      context.pop();
                    },
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          Text("Tìm tài khoản", style: AppStyles.title1Bold),
          const SizedBox(height: 8),
          Text(
            "Nhập email hoặc tên người dùng của bạn.",
            style: AppStyles.title3Regular,
          ),
          InkWell(
            onTap: () {},
            child: Text(
              "Bạn không thể đặt lại mật khẩu?",
              style: AppStyles.title3Regular.copyWith(color: AppColors.blue60),
            ),
          ),
          const SizedBox(width: 32),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: commonTextField(
              labelText: "Tên người dùng,email/số di động",
              controller: _usernameController,
            ),
          ),
          Text(
            'Chúng tôi có thể  gửi cho bạn thông báo  qua SMS và WhatsApp nhằm mục đích bảo mật và đăng nhập.',
          ),
          commonButton(
            text: "Tiếp tục",
            margin: EdgeInsets.symmetric(vertical: 16),
            onTap: () {
              final username = _usernameController.text;
              final password = _passwordController.text;
              context.read<LoginBloc>().add(Login(username, password));
            },
          ),
          commonButton(
            text: "Tìm kiếm bằng số di động",
            color: AppColors.white,
            isBoxBorder: Border.all(color: AppColors.gray30, width: 1),
            margin: EdgeInsets.symmetric(vertical: 0),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _buildBottomSheetCreateAccount(context),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetLanguage(BuildContext context, List<String> items) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),

      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: SvgPicture.asset(AppImages.icClose),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            Text("Chọn ngôn ngữ"),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: AppColors.gray30, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  bool isChecked = false;
                  return Row(
                    children: [
                      Text(items[index]),
                      Checkbox(
                        value: isChecked,
                        side: BorderSide(
                          // màu và độ dày viền
                          color: AppColors.gray40,
                          width: 2,
                        ),
                        checkColor: Colors.white, // màu dấu tích
                        activeColor: Colors.blue,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
