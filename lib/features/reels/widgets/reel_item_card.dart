import 'package:customdropdown/features/reels/data/models/reel_item.dart';
import 'package:customdropdown/features/reels/controller/reels_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelItemCard extends StatelessWidget {
  const ReelItemCard({
    super.key,
    required this.reel,
    required this.index,
    required this.controller,
  });

  final ReelItem reel;
  final int index;
  final ReelsController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _VideoLayer(index: index, controller: controller, reel: reel),
        const _VideoOverlay(),
        _GradientShade(index: index),
        _ReelDetails(reel: reel, controller: controller),
        _ReelActions(reel: reel, controller: controller),
      ],
    );
  }
}

class _VideoLayer extends StatelessWidget {
  const _VideoLayer({
    required this.index,
    required this.controller,
    required this.reel,
  });

  final int index;
  final ReelsController controller;
  final ReelItem reel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReelsController>(
      init: controller,
      id: 'video-$index',
      builder: (_) {
        final player = controller.controllerFor(index);

        if (player == null || !player.value.isInitialized) {
          return _VideoPlaceholder(reel: reel);
        }

        final videoSize = player.value.size;
        final aspectRatio = videoSize.width == 0 || videoSize.height == 0
            ? 9 / 16
            : player.value.aspectRatio;

        return GestureDetector(
          onTap: controller.togglePlayPause,
          child: ColoredBox(
            color: Colors.black,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoSize.width,
                height: videoSize.height,
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(player),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder({required this.reel});

  final ReelItem reel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (reel.thumbnail != null && reel.thumbnail!.isNotEmpty)
          Image.network(reel.thumbnail!, fit: BoxFit.cover)
        else
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF1B1B1B),
                  Color(0xFF090909),
                  Color(0xFF241308),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 72,
                color: Colors.white54,
              ),
            ),
          ),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _VideoOverlay extends StatelessWidget {
  const _VideoOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
    );
  }
}

class _GradientShade extends StatelessWidget {
  const _GradientShade({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.black.withValues(alpha: 0.12),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.58),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const <double>[0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }
}

class _ReelDetails extends StatelessWidget {
  const _ReelDetails({
    required this.reel,
    required this.controller,
  });

  final ReelItem reel;
  final ReelsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      left: 16,
      right: 90,
      bottom: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white10,
                backgroundImage: reel.user.image != null &&
                        reel.user.image!.isNotEmpty
                    ? NetworkImage(reel.user.image!)
                    : null,
                child: reel.user.image == null || reel.user.image!.isEmpty
                    ? Text(
                        reel.user.fullName.isEmpty
                            ? '?'
                            : reel.user.fullName[0].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      reel.user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${reel.user.userName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if ((reel.caption ?? '').trim().isNotEmpty)
            Text(
              reel.caption!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.35),
            ),
          if ((reel.caption ?? '').trim().isNotEmpty)
            const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _InfoChip(
                icon: Icons.local_fire_department_outlined,
                label: 'Trending ${reel.trendingScore}',
              ),
              _InfoChip(
                icon: Icons.remove_red_eye_outlined,
                label: '${controller.formatCount(reel.viewCount)} views',
              ),
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                label: _formatDate(reel.createdAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Unknown date';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ReelActions extends StatelessWidget {
  const _ReelActions({
    required this.reel,
    required this.controller,
  });

  final ReelItem reel;
  final ReelsController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ActionButton(
            icon: reel.likedByMe ? Icons.favorite : Icons.favorite_border,
            label: controller.formatCount(reel.likeCount),
          ),
          const SizedBox(height: 18),
          _ActionButton(
            icon: Icons.mode_comment_outlined,
            label: controller.formatCount(reel.commentCount),
          ),
          const SizedBox(height: 18),
          _ActionButton(
            icon: reel.bookmarkedByMe ? Icons.bookmark : Icons.bookmark_border,
            label: controller.formatCount(reel.bookmarkCount),
          ),
          const SizedBox(height: 18),
          const _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
          ),
          const SizedBox(height: 18),
          const _ActionButton(
            icon: Icons.play_arrow_rounded,
            label: 'Tap',
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
