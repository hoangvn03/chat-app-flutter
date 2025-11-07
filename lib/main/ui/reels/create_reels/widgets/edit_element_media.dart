import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_bloc.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_state.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditElementMedia extends StatefulWidget {
  const EditElementMedia({super.key});

  @override
  State<EditElementMedia> createState() => _EditElementMediaState();
}

class _EditElementMediaState extends State<EditElementMedia> {
  TextAlign _align = TextAlign.center;
  final TextEditingController _controller = TextEditingController();
  final List<String> fonts = [
    'Modern',
    'Classic',
    'Sign',
    'Bold',
    'Typewriter',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReelsBloc, CreateReelsState>(
      builder: (context, state) {
        final current = (state as CreateReelsSuccess).overlay!;
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.3),
          body: SafeArea(
            child: Column(
              children: [
                // Thanh trên cùng
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        context.read<CreateReelsBloc>().add(
                          ToggleHeaderIcons(false),
                        );
                        context.read<CreateReelsBloc>().add(
                          EditTextStory(
                            current.copyWith(content: _controller.text),
                          ),
                        );
                        context.pop();
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
                  ),
                ),
                if (state.overlay != null) ...[
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: RotatedBox(
                            quarterTurns:
                                3, // <<< Xoay 270 độ (3/4 vòng) để nó đứng dọc và kéo từ dưới lên
                            child: Slider(
                              value: state.overlay!.size,
                              onChanged: (v) {
                                context.read<CreateReelsBloc>().add(
                                  EditTextStory(
                                    state.overlay!.copyWith(size: v),
                                  ),
                                );
                                // setState(() => _fontSize = v);
                              },
                              min: 16,
                              max: 72,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white30,
                            ),
                          ),
                        ),
                        // Text nhập
                        Expanded(
                          child: Center(
                            child: TextField(
                              controller: _controller,
                              textAlign: _align,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: state.overlay!.size,
                                color: state.overlay!.color,
                                backgroundColor:
                                    state.overlay!.hasBackground
                                        ? Colors.black.withOpacity(0.5)
                                        : Colors.transparent,
                                fontWeight:
                                    state.overlay!.fontText == 'Bold'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                fontStyle:
                                    state.overlay!.fontText == 'Sign'
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Viết gì đó...',
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Thanh chọn font
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: fonts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final name = fonts[index];
                        return GestureDetector(
                          onTap: () {
                            context.read<CreateReelsBloc>().add(
                              EditTextStory(
                                state.overlay!.copyWith(fontText: name),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  state.overlay!.fontText == name
                                      ? Colors.white
                                      : Colors.white10,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color:
                                      state.overlay!.fontText == name
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Thanh công cụ chỉnh màu / căn lề / nền
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Chọn màu
                        IconButton(
                          icon: const Icon(
                            Icons.color_lens,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final color = await _pickColor(context);
                            if (!mounted) {
                              return; // ✅ đảm bảo context vẫn còn hợp lệ
                            }
                            // ignore: use_build_context_synchronously
                            context.read<CreateReelsBloc>().add(
                              EditTextStory(
                                current.copyWith(
                                  color: color ?? AppColors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        // Căn giữa / trái / phải
                        IconButton(
                          icon: Icon(
                            _align == TextAlign.left
                                ? Icons.format_align_left
                                : _align == TextAlign.center
                                ? Icons.format_align_center
                                : Icons.format_align_right,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_align == TextAlign.left) {
                              _align = TextAlign.center;
                            } else if (_align == TextAlign.center) {
                              _align = TextAlign.right;
                            } else {
                              _align = TextAlign.left;
                            }
                            context.read<CreateReelsBloc>().add(
                              EditTextStory(
                                current.copyWith(textAlign: _align),
                              ),
                            );
                          },
                        ),
                        // Bật / tắt nền
                        IconButton(
                          icon: Icon(
                            state.overlay!.hasBackground
                                ? Icons.rectangle_rounded
                                : Icons.rectangle_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.read<CreateReelsBloc>().add(
                              EditTextStory(
                                state.overlay!.copyWith(
                                  hasBackground: !state.overlay!.hasBackground,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Center(child: Text('Chưa success!')),
                ],
                // Thanh trượt chỉnh size chữ
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Color?> _pickColor(BuildContext context) async {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
    ];
    return showDialog<Color>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              'Chọn màu chữ',
              style: TextStyle(color: Colors.white),
            ),
            content: Wrap(
              spacing: 10,
              children: [
                for (final c in colors)
                  GestureDetector(
                    onTap: () => Navigator.pop(context, c),
                    child: CircleAvatar(backgroundColor: c, radius: 16),
                  ),
              ],
            ),
          ),
    );
  }
}
