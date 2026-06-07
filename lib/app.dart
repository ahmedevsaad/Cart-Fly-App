import 'package:flutter/material.dart';

class CartFlyApp extends StatelessWidget {
  const CartFlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CartFly',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('CartFly — rebuilding')),
      ),
    );
  }
}
