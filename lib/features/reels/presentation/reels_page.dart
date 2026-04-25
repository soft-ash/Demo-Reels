import 'package:customdropdown/features/reels/controller/reels_controller.dart';
import 'package:customdropdown/features/reels/widgets/reel_feed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsController>();

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          if (controller.isFirstLoadRunning.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.reels.isEmpty) {
            return _ErrorState(
              message: controller.errorMessage.value,
              onRetry: controller.loadInitialReels,
            );
          }

          return ReelFeed(controller: controller);
        }),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 52, color: Colors.white70),
            const SizedBox(height: 12),
            const Text(
              'Could not load reels',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
