import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/dev/gallery_screen.dart';

class CartFlyApp extends StatelessWidget {
  const CartFlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CartFly',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const GalleryScreen(),
    );
  }
}
