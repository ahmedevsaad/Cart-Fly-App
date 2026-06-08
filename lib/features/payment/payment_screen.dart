import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../router/routes.dart';
import '../../state/plan_provider.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.forItem});
  final String forItem;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _holderCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _holderCtrl.dispose();
    _cardCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  bool _valid() {
    return _holderCtrl.text.isNotEmpty &&
        _cardCtrl.text.isNotEmpty &&
        _cvvCtrl.text.isNotEmpty &&
        _cardCtrl.text.length >= 12;
  }

  Future<void> _confirm() async {
    final forItem = widget.forItem;
    if (!_valid()) {
      context.go(Routes.paymentError);
      return;
    }
    if (forItem.startsWith('plan_')) {
      final code = forItem.substring('plan_'.length);
      final planProvider = context.read<PlanProvider>();
      final authProvider = context.read<AuthProvider>();
      await planProvider.subscribe(code);
      await authProvider.refreshProfile();
    }
    if (mounted) context.go(Routes.paymentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Payment',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CfInput(label: 'Card holder name', controller: _holderCtrl),
            CfInput(
              label: 'Card number',
              controller: _cardCtrl,
              keyboardType: TextInputType.number,
            ),
            CfInput(
              label: 'CVV',
              controller: _cvvCtrl,
              keyboardType: TextInputType.number,
              obscure: true,
            ),
            const SizedBox(height: 8),
            CfButton(label: 'Confirm', onPressed: _confirm),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
