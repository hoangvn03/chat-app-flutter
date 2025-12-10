import 'package:chat_app/main/networks/model/user.dart';

class ProfileResponse {
  final UserModel user;
  final Stats stats;
  final bool isFollowing;
  ProfileResponse({
    required this.user,
    required this.stats,
    required this.isFollowing,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      user: UserModel.fromJson(json['data']['user']),
      stats: Stats.fromJson(json['data']['stats']),
      isFollowing: json['data']['is_following'] ?? false,
    );
  }
}

class Stats {
  final int followers;
  final int following;
  final int mutualFriends;
  final int blocked;

  Stats({
    required this.followers,
    required this.following,
    required this.mutualFriends,
    required this.blocked,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      followers: json['followers'],
      following: json['following'],
      mutualFriends: json['mutual_friends'],
      blocked: json['blocked'],
    );
  }
}
