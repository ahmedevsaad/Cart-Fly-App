import 'package:flutter/material.dart';
import '../../widgets/cf_scaffold.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const CfScaffold(body: Center(child: Text('Menu')));
}
