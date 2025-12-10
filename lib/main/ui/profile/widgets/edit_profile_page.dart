import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_bloc.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_event.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final UserModel user;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController pronounController;
  late TextEditingController bioController;

  bool showThreads = true;
  String gender = "male";

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller ở đây
    nameController = TextEditingController(
      text: widget.user.fullname ?? "Hoàng Văn Nam",
    );
    usernameController = TextEditingController(
      text: widget.user.username ?? "hoangvannam",
    );
    pronounController = TextEditingController();
    bioController = TextEditingController(text: widget.user.bio ?? "Bio");
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi rời màn hình
    nameController.dispose();
    usernameController.dispose();
    pronounController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context.read<ProfileBloc>().add(
                      EditProfile(
                        UserModel(
                          id: widget.user.id,
                          fullname: nameController.text,
                          username: usernameController.text,
                          bio: bioController.text,
                          gender: gender,
                          status: widget.user.status,
                          email: widget.user.email,
                          avatar: widget.user.avatar,
                          isPrivate: widget.user.isPrivate,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Xong', style: AppStyles.title2Regular),
                  ),
                );
              },
            ),
          ],
          title: const Text(
            "Chỉnh sửa trang cá nhân",
            style: AppStyles.title1Bold,
          ),
        ),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSuccess) {
              context.pushReplacementNamed(PathName.personalPage);
            } else if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: ${state.erroMessage}')),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Ảnh đại diện
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: AppColors.gray20, // nền xám
                        child: SvgPicture.network(
                          widget.user.avatar ??
                              'https://www.svgrepo.com/show/170523/user-profile.svg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholderBuilder:
                              (context) => const Center(
                                child: Icon(
                                  Icons.person_outline,
                                  size: 40,
                                  color: AppColors.gray30,
                                ),
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFEFEFEF),
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    // TODO: Chọn ảnh đại diện
                  },
                  child: const Text(
                    "Đổi ảnh đại diện",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Các trường thông tin
                _buildTextField("Tên", nameController),
                _buildTextField("Tên người dùng", usernameController),
                _buildTextField("Danh xưng", pronounController),
                _buildTextField("Tiểu sử", bioController),
                const SizedBox(height: 8),
                // _buildSectionTitle("Thêm liên kết"),
                // _buildSectionTitle("Biểu ngữ"),
                // const SizedBox(height: 8),
                // _buildDropdownGender(),
                // const SizedBox(height: 8),

                // Nhạc
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Nhạc"),
                  subtitle: const Text(
                    "Thêm nhạc vào trang cá nhân của bạn",
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),

                const SizedBox(height: 8),
                const Divider(),

                // Toggle
                SwitchListTile(
                  title: const Text("Hiển thị biểu ngữ Threads"),
                  subtitle: const Text(
                    "Khi bạn tắt, biểu tượng Instagram trên trang cá nhân Threads cũng sẽ biến mất.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: showThreads,
                  onChanged: (v) => setState(() => showThreads = v),
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper: TextField
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: commonTextField(labelText: label, controller: controller),
    );
  }

  // Widget helper: tiêu đề nhỏ
  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  // Dropdown giới tính
  Widget _buildDropdownGender() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: gender,
        isExpanded: true,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: "Nam", child: Text("Nam")),
          DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
          DropdownMenuItem(value: "Khác", child: Text("Khác")),
        ],
        onChanged: (val) => setState(() => gender = val!),
      ),
    );
  }
}
