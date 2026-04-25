import 'dart:collection';

import 'package:customdropdown/features/reels/data/models/reel_item.dart';
import 'package:customdropdown/features/reels/data/services/reels_api_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelsController extends GetxController {
  ReelsController({required ReelsApiService apiService})
      : _apiService = apiService;

  final ReelsApiService _apiService;
  final PageController pageController = PageController();

  final RxList<ReelItem> reels = <ReelItem>[].obs;
  final RxBool isFirstLoadRunning = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentIndex = 0.obs;

  final Map<int, VideoPlayerController> _videoControllers =
      HashMap<int, VideoPlayerController>();

  String? _nextCursor;
  static const int _pageSize = 10;
  static const int _prefetchThreshold = 2;

  VideoPlayerController? controllerFor(int index) => _videoControllers[index];

  @override
  void onInit() {
    super.onInit();
    loadInitialReels();
  }

  Future<void> loadInitialReels() async {
    isFirstLoadRunning.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.fetchReels(limit: _pageSize);
      reels.assignAll(response.items);
      _nextCursor = response.nextCursor;
      currentIndex.value = 0;
      await _prepareControllersAround(0);
      await _playCurrentVideo();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isFirstLoadRunning.value = false;
    }
  }

  Future<void> onPageChanged(int index) async {
    currentIndex.value = index;
    await _pauseAllExcept(index);
    await _prepareControllersAround(index);
    await _playCurrentVideo();

    final needMore = index >= reels.length - _prefetchThreshold;
    if (needMore) {
      await loadMoreReels();
    }
  }

  Future<void> loadMoreReels() async {
    if (isLoadingMore.value || _nextCursor == null || _nextCursor!.isEmpty) {
      return;
    }

    isLoadingMore.value = true;

    try {
      final response = await _apiService.fetchReels(
        limit: _pageSize,
        cursor: _nextCursor,
      );
      reels.addAll(response.items);
      _nextCursor = response.nextCursor;
      await _prepareControllersAround(currentIndex.value);
    } catch (error) {
      if (errorMessage.value.isEmpty) {
        errorMessage.value = error.toString();
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> togglePlayPause() async {
    final controller = controllerFor(currentIndex.value);
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }

    update(['video-${currentIndex.value}']);
  }

  Future<void> _playCurrentVideo() async {
    final controller = controllerFor(currentIndex.value);
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    await controller.setLooping(true);
    await controller.play();
    update(['video-${currentIndex.value}']);
  }

  Future<void> _pauseAllExcept(int activeIndex) async {
    for (final entry in _videoControllers.entries) {
      if (entry.key != activeIndex && entry.value.value.isInitialized) {
        await entry.value.pause();
        update(['video-${entry.key}']);
      }
    }
  }

  Future<void> _prepareControllersAround(int centerIndex) async {
    if (reels.isEmpty) {
      return;
    }

    final keepAlive = <int>{
      if (centerIndex - 1 >= 0) centerIndex - 1,
      centerIndex,
      if (centerIndex + 1 < reels.length) centerIndex + 1,
    };

    final indexesToDispose = _videoControllers.keys
        .where((index) => !keepAlive.contains(index))
        .toList();

    for (final index in indexesToDispose) {
      final controller = _videoControllers.remove(index);
      await controller?.dispose();
    }

    for (final index in keepAlive) {
      await _initializeController(index);
    }
  }

  Future<void> _initializeController(int index) async {
    if (_videoControllers.containsKey(index)) {
      return;
    }

    final reel = reels[index];
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(reel.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _videoControllers[index] = controller;

    try {
      await controller.initialize();
      await controller.setVolume(1);
    } catch (_) {
      _videoControllers.remove(index);
      await controller.dispose();
    } finally {
      update(['video-$index']);
    }
  }

  String formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return '$count';
  }

  @override
  void onClose() {
    pageController.dispose();
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    super.onClose();
  }
}
