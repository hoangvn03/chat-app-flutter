import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
    Permission.photos, // hoặc Permission.storage với Android cũ
  ].request();
}