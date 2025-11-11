import 'package:chat_app/main/utils/shared_preference.dart';

enum ENV { test, preprod, prod }

class ApiEndPoints {
  static ENV env = ENV.preprod;
  static String? _customDomain;

  static Future<void> init() async {
    final ip = await AppStorage.getCustomIp();
    _updateDomain(ip);
  }

  static void _updateDomain(String? ip) {
    if (ip != null && ip.isNotEmpty) {
      _customDomain = "http://$ip:8080";
    } else {
      switch (env) {
        case ENV.test:
          _customDomain = "http://10.0.2.2:8080";
          break;
        case ENV.preprod:
          _customDomain = "http://192.168.1.77:8080";
          break;
        case ENV.prod:
          _customDomain = "http://192.168.1.77:8080";
          break;
      }
    }
  }

  static Future<void> updateIp(String ip) async {
    await AppStorage.setCustomIp(ip);
    _updateDomain(ip); // 👈 cập nhật trực tiếp mà không cần init lại
  }

  static String get DOMAIN => _customDomain ?? "http://192.168.51.168:8080";

  static String get DOMAISTORYS {
    switch (env) {
      case ENV.test:
        return "https://timordev.ringme.vn/RingMeAPI/story";
      case ENV.preprod:
        return "https://timordev.ringme.vn/RingMeAPI/story";
      case ENV.prod:
        return "https://timordev.ringme.vn/RingMeAPI/story";
      default:
        return "https://timordev.ringme.vn/RingMeAPI/story";
    }
  }

  static String get SIGNIN => "$DOMAIN/api/auth/login";
  static String get SIGNOUT => "$DOMAIN/api/auth/logout";
  static String get PROFILE => "$DOMAIN/api/auth/me";
  static String get FOLLOW => "$DOMAIN/api/follow/2";
  static String get FOLLOWING => "$DOMAIN/api/follow/following";
  static String get FOLLOWERS => "$DOMAIN/api/follow/followers";
  static String get FRIENDS => "$DOMAIN/api/users/me/contacts";
  static String get FOLLOWSUGGESTION => "$DOMAIN/api/follow/suggestions";

  static String get CONVERATIONS => "$DOMAIN/api/conversations";
  static String get GETMESSAGE => "$DOMAIN/api/messages/conversation";
  static String get SENDMESSAGE => "$DOMAIN/api/messages";
  static String get SENDFILE => "$DOMAIN/api/upload/message";

  static String get USERS => "$DOMAIN/api/users";

  static String get NOTIFICATION => "$DOMAIN/api/notifications";
  static String get UNREAD => "$DOMAIN/api/notifications/unread/count";

  static String get LISTSTORY => "$DOMAISTORYS/list";
  static String get UPLOADSTORY => "$DOMAISTORYS/uploadStoryFile";
  static String get GETVIEWERSSTORY => "$DOMAISTORYS/getViewers";
  static String get VIEWSTORY => "$DOMAISTORYS/view";
  static String get REMOTESTORY => "$DOMAISTORYS/removeStory";
  static String get CHECKSTORY => "$DOMAISTORYS/check";

  static String get UPLOADPOST => "$DOMAIN/api/upload/post";
  static String get LOADPOST => "$DOMAIN/api/posts";
}
