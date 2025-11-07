import 'dart:io';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

String formatDateTime(String isoString) {
  // Parse chuỗi ISO
  final dateTime = DateTime.parse(isoString).toLocal();

  // Danh sách thứ bằng tiếng Việt
  const weekdays = [
    'CN', 'Th 2', 'Th 3', 'Th 4', 'Th 5', 'Th 6', 'Th 7'
  ];

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
  // Hàm chuyển đổi MediaOverlay thành chuỗi lệnh drawtext
 Future<String> generateDrawtextFilter(
    MediaOverlay overlay,
    String tempDir, // Cần thư mục tạm để lưu file font
  ) async {
    // 1. Kiểm tra nội dung
    if (overlay.content.isEmpty) {
      return ''; // Không có nội dung để thêm
    }

    // 2. Xử lý Font: Cần đảm bảo file font đã được lưu và có đường dẫn
    // *Bạn phải đảm bảo rằng file font (ví dụ: Roboto-Regular.ttf) đã được sao chép
    // từ assets vào thư mục tạm thời (tempDir) trước khi gọi hàm này.*
    // Giả sử tên file font là 'Roboto-Regular.ttf' và bạn đã có logic sao chép.
    final String fontFileName = '${overlay.fontText}-Regular.ttf'; // Điều chỉnh tên font nếu cần
    final String fontPath = '$tempDir/$fontFileName';

    // 3. Xử lý Màu sắc (FFmpeg cần định dạng Hex)
    // Chuyển Flutter Color sang Hex String (ví dụ: 0xFFFFFFFF -> FFFFFF)
    String colorHex = '#${overlay.color.value.toRadixString(16).substring(2)}';

    // 4. Xử lý Vị trí (x, y): FFmpeg sử dụng tọa độ tỷ lệ (0-1) hoặc biểu thức
    // Tọa độ x và y trong MediaOverlay là tỷ lệ (0.0 đến 1.0)
    // Chúng ta sử dụng biểu thức FFmpeg để căn chỉnh:
    // x=(W-text_w)*overlay.x
    // y=(H-text_h)*overlay.y

    // Căn chỉnh vị trí dựa trên tọa độ tỷ lệ (x, y)
    // FFmpeg tính từ góc trên bên trái của Text.
    // Nếu x=0.5, y=0.5, nó sẽ đặt góc trên bên trái của text ở giữa màn hình.
    // Để căn giữa thực sự (center-aligned), bạn cần trừ đi nửa chiều rộng/chiều cao của text.
    
    // Sử dụng biểu thức căn chỉnh (sử dụng w và h của text_w, text_h)
    // Để căn giữa (text_w/2) tại tọa độ x=0.5: x=(W/2) - (text_w/2) = (W-text_w)/2
    
    // x = (W - text_w) * X_RATIO
    // y = (H - text_h) * Y_RATIO
    // Trong đó W và H là kích thước của video/ảnh.

    final String xPosExpression = '(w - text_w) * ${overlay.x}';
    final String yPosExpression = '(h - text_h) * ${overlay.y}';

    // 5. Xử lý Background (Box):
    String boxSetting = '';
    String boxPadding = '';
    if (overlay.hasBackground) {
      // Đặt màu nền đen mờ 50% (black@0.5)
      boxSetting = ':box=1:boxcolor=black@0.5'; 
      boxPadding = ':boxborderw=10'; // Thêm padding cho box
    }

    // 6. Xử lý Căn chỉnh Text (textAlign):
    // FFmpeg drawtext không hỗ trợ căn chỉnh text đa dòng phức tạp như Flutter TextAlign.
    // Nó căn chỉnh theo tọa độ x, y. Nếu nội dung là một dòng, bạn có thể dùng tọa độ.
    // Nếu là đa dòng, bạn cần tự thêm ký tự xuống dòng (\n) và điều chỉnh x/y.
    
    // Để đơn giản, ta chỉ tập trung vào x, y:
    
    // Final drawtext command
    final String drawtextCommand = 
      'drawtext=' +
      // Đường dẫn font
      "fontfile='$fontPath':" +
      // Nội dung (cần escape các ký tự đặc biệt)
      "text='${overlay.content.replaceAll("'", r"\'")}':" + 
      // Kích thước
      "fontsize=${overlay.size}:" +
      // Màu
      "fontcolor=$colorHex:" +
      // Vị trí
      "x=$xPosExpression:" +
      "y=$yPosExpression" +
      // Background
      boxSetting +
      boxPadding;

    return drawtextCommand;
  }


// Hàm này sẽ được gọi trong logic FFmpeg của bạn
/*
// Ví dụ sử dụng:
String tempDir = (await getTemporaryDirectory()).path;
MediaOverlay myOverlay = MediaOverlay(
  content: "Xin chào FFmpeg!",
  x: 0.1, // Góc trên bên trái
  y: 0.1,
  hasBackground: true,
  color: AppColors.red, // Giả sử AppColors.red là một Flutter Color
);

String drawtextCmd = await FFmpegUtils.generateDrawtextFilter(myOverlay, tempDir);

// Nếu bạn cần thêm các filter khác:
// final String filterCommand = '$colorFilter, $drawtextCmd';
// command = '-i ${inputFile.path} -vf "$filterCommand" ...';
*/
