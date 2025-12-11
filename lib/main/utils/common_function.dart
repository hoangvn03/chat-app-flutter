import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

String formatDateTime(String isoString) {
  // Parse chuỗi ISO
  final dateTime = DateTime.parse(isoString).toLocal();

  // Danh sách thứ bằng tiếng Việt
  const weekdays = ['CN', 'Th 2', 'Th 3', 'Th 4', 'Th 5', 'Th 6', 'Th 7'];

  final weekday = weekdays[dateTime.weekday % 7];
  final time = DateFormat('HH:mm').format(dateTime);

  return '$weekday $time';
}

String formatDateTimeV2(DateTime? dateTime) {
  if (dateTime == null) return '';
  final formatter = DateFormat('HH:mm - dd/MM/yyyy');
  return formatter.format(dateTime);
}

String formatDateTimeV3(DateTime? dateTime) {
  if (dateTime == null) return '';

  final hourMinute = DateFormat('HH:mm').format(dateTime);
  final day = dateTime.day;
  final month = dateTime.month;

  return '$hourMinute Ngày $day tháng $month';
}

String formatDateTimeV4(DateTime? dateTime) {
  if (dateTime == null) return '';

  final now = DateTime.now();
  final diff = now.difference(dateTime);

  /// Giây
  if (diff.inSeconds < 60) {
    if (diff.inSeconds <= 0) return "vừa xong";
    return "${diff.inSeconds} giây trước";
  }

  /// Phút
  if (diff.inMinutes < 60) {
    return "${diff.inMinutes} phút trước";
  }

  /// Giờ
  if (diff.inHours < 24) {
    return "${diff.inHours} giờ trước";
  }

  /// Hôm qua
  if (diff.inDays == 1) {
    return "1 ngày trước";
  }

  /// Ngày trong tuần (1–6 ngày)
  if (diff.inDays < 7) {
    return "${diff.inDays} ngày trước";
  }

  /// Tuần
  final weeks = (diff.inDays / 7).floor();
  if (weeks == 1) {
    return "1 tuần trước";
  }
  if (weeks > 1 && weeks < 5) {
    return "$weeks tuần trước";
  }

  /// Lớn hơn vài tuần => trả về format đầy đủ
  final hourMinute = DateFormat('HH:mm').format(dateTime);
  return "$hourMinute Ngày ${dateTime.day} tháng ${dateTime.month}";
}

Future<List<File>> convertAssetEntitiesToFiles(List<AssetEntity> assets) async {
  final List<File> files = [];

  for (final asset in assets) {
    final file = await asset.file;
    if (file != null && await file.exists()) {
      files.add(file);
    }
  }

  return files;
}

List<File> pathsToFiles(List<String> paths) {
  return paths.map((p) => File(p)).toList();
}

Future<List<File>> uint8ListListToFileList(
  List<Uint8List> bytesList,
  String fileNamePrefix,
) async {
  final tempDir = await getTemporaryDirectory();
  List<File> files = [];

  for (int i = 0; i < bytesList.length; i++) {
    final file = File('${tempDir.path}/$fileNamePrefix$i.jpg');
    await file.writeAsBytes(bytesList[i], flush: true);
    files.add(file);
  }

  return files;
}

Future<File> urlToFile(String mediaUrl) async {
  final response = await http.get(Uri.parse(mediaUrl));

  if (response.statusCode != 200) {
    throw Exception("Không tải được media từ URL");
  }

  final tempDir = await getTemporaryDirectory();

  // Lấy extension từ URL
  final uri = Uri.parse(mediaUrl);
  final extension = uri.path.split('.').last; // png, jpg, mp4, mov...

  final filePath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.$extension';

  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);

  return file;
}

String formatDuration(int milliseconds) {
  final seconds = (milliseconds / 1000).truncate();
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return "$minutes:$remainingSeconds";
}
