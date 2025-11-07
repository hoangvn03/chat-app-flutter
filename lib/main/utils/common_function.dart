import 'dart:io';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
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


