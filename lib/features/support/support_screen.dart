import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _form = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _msg = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _subject.dispose();
    _msg.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('support').add({
      'uid': uid,
      'subject': _subject.text.trim(),
      'message': _msg.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      setState(() {
        _busy = false;
        _sent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    String? req(String? v) => (v == null || v.isEmpty) ? t.errorRequired : null;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 28),
                    onPressed: () => context.pop(),
                  ),
                  Text(t.support,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: t.supportSubject,
                    controller: _subject,
                    validator: req,
                  ),
                  Text(t.supportMessage,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _msg,
                    maxLines: 6,
                    validator: req,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _send,
                      child: Text(t.send),
                    ),
                  ),
                  if (_sent)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('Sent. Thanks!'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
