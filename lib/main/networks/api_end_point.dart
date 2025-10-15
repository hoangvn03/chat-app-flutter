enum ENV { test, preprod, prod }

class ApiEndPoints {
  static ENV env = ENV.preprod;
  static String get DOMAIN {
    switch (env) {
      case ENV.test:
        return "http://10.0.2.2:3000"; // fix from port 9909
      case ENV.preprod:
        return "http://192.168.1.77:3000";
      case ENV.prod:
        return "http://181.176.242.147:9901/ftth";
      default:
        return "http://10.121.14.196:9909";
    }
  }

  static String get SIGNIN => "$DOMAIN/api/auth/login";
  static String get SIGNOUT => "$DOMAIN/api/auth/logout";
  static String get PROFILE => "$DOMAIN/api/auth/me";

  static String get USERINFO => "$DOMAIN/api/v1/user/getUser";
  static String get DELETEUSER => "$DOMAIN/api/delete_user";
  static String get UPDATEUSER => "$DOMAIN/api/update_user";
}
