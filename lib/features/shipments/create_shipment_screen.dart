import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/lockers.dart';
import '../../data/models/order.dart';
import '../../data/warehouses.dart';
import '../../state/orders_provider.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  State<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  final _title = TextEditingController();
  String _country = warehouses.first.code;
  DeliveryMethod _method = DeliveryMethod.home;
  String? _lockerId;
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final titleText = _title.text.trim();
    if (titleText.isEmpty) return;
    setState(() => _loading = true);
    final provider = context.read<OrdersProvider>();
    try {
      final id = await provider.create(Order(
            id: '',
            title: titleText,
            sourceCountry: _country,
            deliveryMethod: _method,
            lockerId: _method == DeliveryMethod.locker ? _lockerId : null,
            status: OrderStatus.placed,
            createdAt: DateTime.now(),
          ));
      if (mounted) context.pushReplacement('/orders/$id/track');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockerCountry = countryLockers
        .where((c) => c.code == _country)
        .firstOrNull;
    final allLockers = lockerCountry?.cities
            .expand((city) => city.lockers)
            .toList() ??
        [];

    return CfScaffold(
      topBar: const CfTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CfInput(
              label: 'Item / title',
              controller: _title,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _country,
              decoration: const InputDecoration(labelText: 'Source country'),
              items: warehouses
                  .map((w) => DropdownMenuItem(
                        value: w.code,
                        child: Text(w.displayName),
                      ))
                  .toList(),
              onChanged: (v) => setState(() {
                _country = v!;
                _lockerId = null;
              }),
            ),
            const SizedBox(height: 16),
            const Text('Delivery method'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MethodButton(
                    label: 'Home',
                    selected: _method == DeliveryMethod.home,
                    onTap: () => setState(() => _method = DeliveryMethod.home),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MethodButton(
                    label: 'Locker',
                    selected: _method == DeliveryMethod.locker,
                    onTap: () =>
                        setState(() => _method = DeliveryMethod.locker),
                  ),
                ),
              ],
            ),
            if (_method == DeliveryMethod.locker && allLockers.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _lockerId,
                decoration: const InputDecoration(labelText: 'Select locker'),
                items: allLockers
                    .map((l) => DropdownMenuItem(
                          value: l.name,
                          child: Text('${l.name} – ${l.spot}'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _lockerId = v),
              ),
            ],
            const SizedBox(height: 32),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : CfButton(label: 'Create', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  const _MethodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(color: theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
