import 'package:customdropdown/features/reels/data/models/reel_user.dart';

class ReelItem {
  const ReelItem({
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.duration,
    required this.createdAt,
    required this.trendingScore,
    required this.likedByMe,
    required this.bookmarkedByMe,
    required this.likeCount,
    required this.commentCount,
    required this.bookmarkCount,
    required this.viewCount,
    required this.user,
  });

  final String id;
  final String? caption;
  final String videoUrl;
  final String? thumbnail;
  final int duration;
  final DateTime? createdAt;
  final int trendingScore;
  final bool likedByMe;
  final bool bookmarkedByMe;
  final int likeCount;
  final int commentCount;
  final int bookmarkCount;
  final int viewCount;
  final ReelUser user;

  factory ReelItem.fromJson(Map<String, dynamic> json) {
    return ReelItem(
      id: json['id'] as String? ?? '',
      caption: json['caption'] as String?,
      videoUrl: json['video'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
      duration: json['duration'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      trendingScore: json['trendingScore'] as int? ?? 0,
      likedByMe: json['likedByMe'] as bool? ?? false,
      bookmarkedByMe: json['bookmarkedByMe'] as bool? ?? false,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      bookmarkCount: json['bookmarkCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      user: ReelUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
