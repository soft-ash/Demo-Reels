import 'package:customdropdown/features/reels/data/models/reel_item.dart';
import 'package:customdropdown/features/reels/data/models/reel_user.dart';
import 'package:customdropdown/features/reels/data/models/reels_response.dart';
import 'package:customdropdown/features/reels/data/services/reels_api_service.dart';
import 'package:customdropdown/features/reels/controller/reels_controller.dart';
import 'package:customdropdown/features/reels/widgets/reel_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('reel feed renders header and caption', (WidgetTester tester) async {
    final controller = ReelsController(apiService: _FakeReelsApiService());
    controller.isFirstLoadRunning.value = false;
    controller.reels.assignAll(<ReelItem>[
      ReelItem(
        id: '1',
        caption: 'Cute puppy reel',
        videoUrl: 'https://example.com/video.mp4',
        thumbnail: null,
        duration: 0,
        createdAt: DateTime(2026, 4, 21),
        trendingScore: 4,
        likedByMe: false,
        bookmarkedByMe: false,
        likeCount: 12,
        commentCount: 3,
        bookmarkCount: 1,
        viewCount: 120,
        user: const ReelUser(
          id: 'u1',
          fullName: 'Pet Lover',
          userName: 'pet-lover',
          image: null,
        ),
      ),
    ]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: ReelFeed(controller: controller),
        ),
      ),
    );

    expect(find.text('Reels'), findsOneWidget);
    expect(find.text('Cute puppy reel'), findsOneWidget);
  });
}

class _FakeReelsApiService extends ReelsApiService {
  @override
  Future<ReelsResponse> fetchReels({required int limit, String? cursor}) {
    throw UnimplementedError();
  }
}
