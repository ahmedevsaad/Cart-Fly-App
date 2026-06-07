import 'package:flutter/material.dart';
import '../../widgets/cf_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const CfScaffold(body: Center(child: Text('Profile')));
}
