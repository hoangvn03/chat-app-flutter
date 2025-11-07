import 'dart:io';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/utils/common_function.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class FFmpegHelper {
  // Hàm thực thi lệnh FFmpeg
  static Future<File?> _executeFfmpegCommand(
    String command,
    String outputPath,
  ) async {
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print("✅ FFmpeg command executed successfully.");
      return File(outputPath);
    } else {
      final log = await session.getLogsAsString();
      print("❌ FFmpeg command failed. Command: $command");
      print("Log: $log");
      return null;
    }
  }

  // Hàm Xây dựng và Chạy FFmpeg để Chỉnh sửa Media
  static Future<File?> processMediaForStory(
    AssetEntity asset, {
    MediaOverlay? overlay,
    String? textOverlay,
    String? colorFilter,
    String? logoPath,
  }) async {
    final File? inputFile = await asset.originFile;
    if (inputFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final isVideo = asset.type == AssetType.video;
    final extension = isVideo ? 'mp4' : 'jpg';
    final outputPath =
        '${tempDir.path}/edited_story_${DateTime.now().millisecondsSinceEpoch}.$extension';

    // --- CÁC THAM SỐ CHỈNH SỬA (Customizable) ---

    // 1. Chỉnh màu: Tăng độ bão hòa (Saturation) lên 1.5, Độ tương phản 1.1
    // Áp dụng tông màu ấm/vàng: Giảm Blue, Tăng Red và Green nhẹ
    const String colorFilter =
        'eq=gamma_r=1.2:gamma_g=1.1:gamma_b=0.85:saturation=1.1:contrast=1.1';
    // 2. Thêm Text: "RingMe Story" ở dưới cùng
    final fontData = await rootBundle.load(
      'assets/fonts/roboto/Roboto-Regular.ttf',
    );
    final fontFile = File('${tempDir.path}/Roboto-Regular.ttf');
    await fontFile.writeAsBytes(fontData.buffer.asUint8List());
    final fontPath = fontFile.path;
    // 📝 Thêm text với fontfile
    final String textOverlay =
        overlay != null
            ? await generateDrawtextFilter(overlay, tempDir.path)
            : "drawtext=fontfile='$fontPath':text='RingMe Story':fontcolor=white:fontsize=48:x=(w-text_w)/2:y=h-th-50:box=1:boxcolor=black@0.5";

    // 3. Thêm Ảnh/Logo (Watermark): Cần đường dẫn file logo thực tế.
    // LƯU Ý: Nếu không có file logo, lệnh sẽ dùng filter đơn giản.
    final String logoPath =
        '/path/to/your/logo_watermark.png'; // Thay thế bằng đường dẫn thực tế

    String command = '';

    if (File(logoPath).existsSync()) {
      // --- Sử dụng Complex Filtergraph (có Logo) ---

      final String filterCommand =
          '[0:v]$colorFilter[v0];' +
          '[v0]$textOverlay[v1];' + // Thêm text vào v0
          '[1:v]scale=w=100:h=100[logo];' + // Scale logo (Stream 1)
          '[v1][logo]overlay=W-w-10:10[out]'; // Overlay logo lên v1

      command =
          '-i ${inputFile.path} -i $logoPath -filter_complex "$filterCommand" ${isVideo ? '-c:v libx264 -preset fast -crf 23 ' : ''}-map "[out]" -y $outputPath';
    } else {
      // --- Sử dụng Simple Filter (Không có Logo) ---

      final String filterCommand = '$colorFilter, $textOverlay';
      command =
          '-i ${inputFile.path} -vf "$filterCommand" ${isVideo ? '-c:v libx264 -preset fast -crf 23 ' : ''}-y $outputPath';
    }

    return await _executeFfmpegCommand(command, outputPath);
  }

  static Future<File?> processMediaForStoryV2(AssetEntity asset) async {
    final File? inputFile = await asset.originFile;
    if (inputFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final isVideo = asset.type == AssetType.video;
    final extension = isVideo ? 'mp4' : 'jpg';
    final outputPath =
        '${tempDir.path}/edited_story_${DateTime.now().millisecondsSinceEpoch}.$extension';

    // 🔤 Tải font từ assets
    final fontData = await rootBundle.load(
      'assets/fonts/roboto/Roboto-Regular.ttf',
    );
    final fontFile = File('${tempDir.path}/Roboto-Regular.ttf');
    await fontFile.writeAsBytes(fontData.buffer.asUint8List());
    final fontPath = fontFile.path;

    // 🎨 Filter chỉnh màu
    const String colorFilter = 'eq=saturation=1.5:contrast=1.1';

    // 📝 Thêm text với fontfile
    final String textOverlay =
        "drawtext=fontfile='$fontPath':text='RingMe Story':fontcolor=white:fontsize=48:x=(w-text_w)/2:y=h-th-50:box=1:boxcolor=black@0.5";

    final String filterCommand = '$colorFilter, $textOverlay';
    final command =
        '-i ${inputFile.path} -vf "$filterCommand" ${isVideo ? '-c:v libx264 -preset fast -crf 23 ' : ''}-y $outputPath';

    return await _executeFfmpegCommand(command, outputPath);
  }
}
