import 'package:customdropdown/features/reels/controller/reels_controller.dart';
import 'package:customdropdown/features/reels/widgets/reel_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReelFeed extends StatelessWidget {
  const ReelFeed({super.key, required this.controller});

  final ReelsController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: controller.pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: controller.onPageChanged,
          itemCount: controller.reels.length,
          itemBuilder: (context, index) {
            final reel = controller.reels[index];
            return ReelItemCard(
              reel: reel,
              index: index,
              controller: controller,
            );
          },
        ),
        const _TopLabel(),
        Obx(() {
          if (!controller.isLoadingMore.value) {
            return const SizedBox.shrink();
          }

          return const Positioned(
            right: 18,
            top: 64,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text('Loading more'),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _TopLabel extends StatelessWidget {
  const _TopLabel();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 64,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Reels',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Smooth feed with preload and pagination',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
