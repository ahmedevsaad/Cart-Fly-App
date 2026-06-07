import 'package:flutter/material.dart';
import '../../widgets/cf_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const CfScaffold(body: Center(child: Text('Settings')));
}
