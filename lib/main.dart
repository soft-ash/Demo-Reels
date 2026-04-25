import 'package:customdropdown/features/reels/controller/reels_binding.dart';
import 'package:customdropdown/features/reels/presentation/reels_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const ReelApp());
}

class ReelApp extends StatelessWidget {
  const ReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petzy Reels',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7A18),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: AppRoutes.reels,
      getPages: <GetPage<dynamic>>[
        GetPage(
          name: AppRoutes.reels,
          page: () => const ReelsPage(),
          binding: ReelsBinding(),
        ),
      ],
    );
  }
}

class AppRoutes {
  static const String reels = '/';
}
