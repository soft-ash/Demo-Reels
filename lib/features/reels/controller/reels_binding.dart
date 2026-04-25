import 'package:customdropdown/features/reels/data/services/reels_api_service.dart';
import 'package:customdropdown/features/reels/controller/reels_controller.dart';
import 'package:get/get.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsApiService>(() => ReelsApiService());
    Get.put(ReelsController(apiService: Get.find<ReelsApiService>()));
  }
}
