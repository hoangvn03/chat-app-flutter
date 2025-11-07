import 'dart:io';
import 'package:chat_app/main/networks/model/reels.dart';
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

  // Hàm chính - điều phối các bước xử lý
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

    // Xây dựng command FFmpeg
    String command = await _buildFFmpegCommand(
      inputFile: inputFile,
      tempDir: tempDir,
      isVideo: isVideo,
      outputPath: outputPath,
      overlay: overlay,
      logoPath: logoPath,
    );

    return await _executeFfmpegCommand(command, outputPath);
  }

  // Hàm xây dựng command FFmpeg
  static Future<String> _buildFFmpegCommand({
    required File inputFile,
    required Directory tempDir,
    required bool isVideo,
    required String outputPath,
    MediaOverlay? overlay,
    String? logoPath,
  }) async {
    final bool hasLogo = logoPath != null && await File(logoPath).exists();

    if (hasLogo) {
      return _buildComplexFilterCommand(
        inputFile: inputFile,
        tempDir: tempDir,
        isVideo: isVideo,
        outputPath: outputPath,
        overlay: overlay,
        logoPath: logoPath,
      );
    } else {
      return _buildSimpleFilterCommand(
        inputFile: inputFile,
        tempDir: tempDir,
        isVideo: isVideo,
        outputPath: outputPath,
        overlay: overlay,
      );
    }
  }

  // Hàm tạo color filter
  static String _getColorFilter() {
    return 'eq=gamma_r=1.2:gamma_g=1.1:gamma_b=0.85:saturation=1.1:contrast=1.1';
  }

  // Hàm tạo text overlay filter
  static Future<String> _getTextOverlayFilter({
    required Directory tempDir,
    MediaOverlay? overlay,
  }) async {
    if (overlay != null) {
      return _generateDrawtextFilter(overlay, tempDir.path);
    }
    // Default text overlay
    final fontPath = await _prepareFontFile(tempDir);
    return "drawtext=fontfile='$fontPath':text='RingMe Story':fontcolor=white:fontsize=48:x=(w-text_w)/2:y=h-th-50:box=1:boxcolor=black@0.5";
  }

  // Hàm chuẩn bị font file
  static Future<String> _prepareFontFile(Directory tempDir) async {
    final fontData = await rootBundle.load(
      'assets/fonts/roboto/Roboto-Regular.ttf',
    );
    final fontFile = File('${tempDir.path}/Roboto-Regular.ttf');
    await fontFile.writeAsBytes(fontData.buffer.asUint8List());
    return fontFile.path;
  }

  // Hàm xây dựng command với complex filter (có logo)
  static Future<String> _buildComplexFilterCommand({
    required File inputFile,
    required Directory tempDir,
    required bool isVideo,
    required String outputPath,
    MediaOverlay? overlay,
    required String logoPath,
  }) async {
    final colorFilter = _getColorFilter();
    final textOverlay = await _getTextOverlayFilter(
      tempDir: tempDir,
      overlay: overlay,
    );

    final filterCommand =
        '[0:v]$colorFilter[color];' +
        '[color]$textOverlay[text];' +
        '[1:v]scale=w=100:h=100[logo];' +
        '[text][logo]overlay=W-w-10:10[out]';

    return '-i ${inputFile.path} ' +
        '-i $logoPath ' +
        '-filter_complex "$filterCommand" ' +
        '-map "[out]" ' +
        (isVideo ? '-c:v libx264 -preset fast -crf 23 ' : '') +
        (isVideo ? '-c:a copy ' : '') +
        '-y $outputPath';
  }

  // Hàm xây dựng command với simple filter (không logo)
  static Future<String> _buildSimpleFilterCommand({
    required File inputFile,
    required Directory tempDir,
    required bool isVideo,
    required String outputPath,
    MediaOverlay? overlay,
  }) async {
    final colorFilter = _getColorFilter();
    final textOverlay = await _getTextOverlayFilter(
      tempDir: tempDir,
      overlay: overlay,
    );

    final filterCommand = '$colorFilter, $textOverlay';

    return '-i ${inputFile.path} ' +
        '-vf "$filterCommand" ' +
        (isVideo ? '-c:v libx264 -preset fast -crf 23 ' : '') +
        (isVideo ? '-c:a copy ' : '') +
        '-y $outputPath';
  }

  static Future<String> _generateDrawtextFilter(
    MediaOverlay overlay,
    String tempDir, // Cần thư mục tạm để lưu file font
  ) async {
    if (overlay.content.isEmpty) {
      return '';
    }
    final String fontFileName =
        '${overlay.fontText}-Regular.ttf'; // Điều chỉnh tên font nếu cần
    final String fontPath = '$tempDir/$fontFileName';
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

    final String xPosExpression = '(w - text_w)*${overlay.x}';
    final String yPosExpression = '(h - text_h)*${overlay.y}';

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
        "fontfile='$fontPath':" +
        "text='${overlay.content.replaceAll("'", r"\'")}':" +
        "fontsize=${overlay.size * 3}:" +
        "fontcolor=$colorHex:" +
        "x=$xPosExpression:" +
        "y=$yPosExpression" +
        boxSetting +
        boxPadding;

    return drawtextCommand;
  }

  // Hàm thêm audio handling (nếu cần xử lý riêng)
  static String _getAudioHandling({required bool isVideo}) {
    if (!isVideo) return '';
    return '-c:a aac -b:a 128k'; // Hoặc '-c:a copy' để giữ nguyên
  }

  // Hàm thêm video encoding options (nếu cần tùy chỉnh)
  static String _getVideoEncodingOptions({required bool isVideo}) {
    if (!isVideo) return '';
    return '-c:v libx264 -preset fast -crf 23';
  }
}
