import 'dart:convert';

import 'package:customdropdown/features/reels/data/models/reel_item.dart';

class ReelsResponse {
  const ReelsResponse({
    required this.items,
    required this.nextCursor,
  });

  final List<ReelItem> items;
  final String? nextCursor;

  factory ReelsResponse.fromJson(Map<String, dynamic> json) {
    final rootData = json['data'] as Map<String, dynamic>? ?? {};
    final itemList = rootData['data'] as List<dynamic>? ?? <dynamic>[];

    return ReelsResponse(
      items: itemList
          .map((item) => ReelItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      nextCursor: rootData['nextCursor'] as String?,
    );
  }
}

ReelsResponse parseReelsResponse(String body) {
  final decoded = jsonDecode(body) as Map<String, dynamic>;
  return ReelsResponse.fromJson(decoded);
}
