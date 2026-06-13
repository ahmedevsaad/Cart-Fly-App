import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/user_repository.dart';
import '../../features/auth/auth_provider.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

const _countries = [
  'Saudi Arabia',
  'UAE',
  'Egypt',
  'USA',
  'China',
  'Kuwait',
  'Qatar',
  'Bahrain',
  'Oman',
  'Jordan',
];

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  String? _country;


  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().state.user;
    _name = TextEditingController(text: user?.name ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
    _country = user?.country.isNotEmpty == true ? user?.country : null;
    if (_country != null && !_countries.contains(_country)) {
      _country = null;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final authProv = context.read<AuthProvider>();
    final uid = authProv.state.user?.uid;
    if (uid == null) return;
    // Persist best-effort in the background and return immediately, so a slow/
    // unreachable Firestore can't freeze the Save button.
    unawaited(
      UserRepository(db: FirebaseFirestore.instance, uid: uid)
          .updateProfile(
            name: _name.text.trim(),
            phone: _phone.text.trim(),
            country: _country,
          )
          .then((_) => authProv.refreshProfile())
          .catchError((_) {}),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CfInput(label: 'Full name:', controller: _name),
            CfInput(
              label: 'Phone:',
              controller: _phone,
              keyboardType: TextInputType.phone,
            ),
            const Text('Country:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _country,
              items: _countries
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _country = v),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 24),
            CfButton(
              label: 'Save',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
