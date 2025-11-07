import 'dart:ui';

import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaType { image, video }

class ReelModel {
  UserModel? user;
  String? images;
  String? url;
  MediaType? media;
  Duration? duration;
  String? text;
  List<dynamic>? assetList;
  ReelModel({
    this.user,
    this.images,
    this.text,
    this.url,
    this.media,
    this.duration,
    this.assetList,
  });
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      images: json['images'],
      text: json['text'],
    );
  }
}

class UploadResponse {
  final int errorCode;
  final String desc;
  final String id;

  UploadResponse({
    required this.errorCode,
    required this.desc,
    required this.id,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      errorCode: json['errorCode'] ?? 0,
      desc: json['desc'] ?? '',
      id: json['ID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'errorCode': errorCode, 'desc': desc, 'ID': id};
  }
}

// Định nghĩa một class/enum để đại diện cho các loại lớp phủ
enum OverlayType { text, sticker }

class MediaOverlay {
  final OverlayType type;
  final String content;
  final double x;
  final double y;
  final String fontText;
  final double size;
  final Color color;
  final bool hasBackground;
  final TextAlign textAlign;
  final Color? filter;

  MediaOverlay({
    this.type = OverlayType.text, // 👈 mặc định là text
    this.content = '',
    this.x = 0.5, // 👈 giữa màn hình
    this.y = 0.5,
    this.fontText = 'Roboto',
    this.size = 24,
    this.color = AppColors.white, // 👈 trắng
    this.hasBackground = false, // 👈 trắng
    this.textAlign = TextAlign.center, // 👈 trắng,
    this.filter,
  });
  MediaOverlay copyWith({
    OverlayType? type,
    String? content,
    double? x,
    double? y,
    String? fontText,
    double? size,
    Color? color,
    bool? hasBackground,
    TextAlign? textAlign,
    Color? filter,
  }) {
    return MediaOverlay(
      type: type ?? this.type,
      content: content ?? this.content,
      x: x ?? this.x,
      y: y ?? this.y,
      fontText: fontText ?? this.fontText,
      size: size ?? this.size,
      color: color ?? this.color,
      hasBackground: hasBackground ?? this.hasBackground,
      textAlign: textAlign ?? this.textAlign,
      filter: filter ?? this.filter,
    );
  }
}

class MediaFilter {
  final String name;
  final String ffmpegCommand; // Ví dụ: 'eq=saturation=1.5:contrast=1.1'

  MediaFilter({required this.name, required this.ffmpegCommand});
}
