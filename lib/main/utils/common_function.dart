import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:flutter/material.dart';

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

Future<List<File>> uint8ListListToFileList(
    List<Uint8List> bytesList, String fileNamePrefix) async {
  final tempDir = await getTemporaryDirectory();
  List<File> files = [];

  for (int i = 0; i < bytesList.length; i++) {
    final file = File('${tempDir.path}/$fileNamePrefix$i.jpg');
    await file.writeAsBytes(bytesList[i], flush: true);
    files.add(file);
  }

  return files;
}

String formatDuration(int milliseconds) {
  final seconds = (milliseconds / 1000).truncate();
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return "$minutes:$remainingSeconds";
}


