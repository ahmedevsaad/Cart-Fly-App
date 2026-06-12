import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'cf_background.dart';

/// Scaffold wrapper that applies the CartFly background and safe-area.
///
/// Stable public API: [body], [topBar], [bottomNav], [solidBackground].
class CfScaffold extends StatelessWidget {
  const CfScaffold({
    super.key,
    required this.body,
    this.topBar,
    this.bottomNav,
    this.solidBackground,
  });

  final Widget body;
  final PreferredSizeWidget? topBar;
  final Widget? bottomNav;
  final Color? solidBackground;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: solidBackground ?? AppColors.bgPage,
      appBar: topBar,
      bottomNavigationBar: bottomNav,
      body: CfBackground(
        solid: solidBackground,
        child: SafeArea(child: body),
      ),
    );
  }
}
