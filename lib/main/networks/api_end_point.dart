enum ENV { test, preprod, prod }

class ApiEndPoints {
  static ENV env = ENV.preprod;
  static String get DOMAIN {
    switch (env) {
      case ENV.test:
        return "http://10.0.2.2:3000"; // fix from port 9909
      case ENV.preprod:
        // return "http://192.168.1.77:3000";
        return "http://192.168.51.168:3000";
      case ENV.prod:
        return "http://181.176.242.147:9901/ftth";
      default:
        return "http://10.121.14.196:9909";
    }
  }

  static String get DOMAININIT => DOMAIN;

  static String get SIGNIN => "$DOMAIN/api/auth/login";
  static String get SIGNOUT => "$DOMAIN/api/auth/logout";
  static String get PROFILE => "$DOMAIN/api/auth/me";
  static String get FOLLOW => "$DOMAIN/api/follow/2";
  static String get FOLLOWING => "$DOMAIN/api/follow/following";
  static String get FOLLOWERS => "$DOMAIN/api/follow/followers";
  static String get FRENDS => "$DOMAIN/api/follow/friends";
  static String get FOLLOWSUGGESTION => "$DOMAIN/api/follow/suggestions";

  static String get CONVERATIONS => "$DOMAIN/api/conversations";
  static String get GETMESSAGE => "$DOMAIN/api/messages/conversation";
  static String get SENDMESSAGE => "$DOMAIN/api/messages";


  static String get USERINFO => "$DOMAIN/api/v1/user/getUser";
  static String get DELETEUSER => "$DOMAIN/api/delete_user";
  static String get UPDATEUSER => "$DOMAIN/api/update_user";
}
