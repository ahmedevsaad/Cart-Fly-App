import 'package:flutter/material.dart';
import '../../widgets/cf_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const CfScaffold(body: Center(child: Text('Home')));
}
