import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../models/vendor.dart';
import '../widgets/common/common_widgets.dart';

class AddEditVendorScreen extends ConsumerStatefulWidget {
  final Vendor? vendor;
  const AddEditVendorScreen({super.key, this.vendor});
  @override
  ConsumerState<AddEditVendorScreen> createState() => _AddEditVendorScreenState();
}

class _AddEditVendorScreenState extends ConsumerState<AddEditVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _gstCtrl     = TextEditingController();
  final _notesCtrl   = TextEditingController();
  bool _saving = false;
  bool get _isEdit => widget.vendor != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final v = widget.vendor!;
      _nameCtrl.text    = v.name;
      _phoneCtrl.text   = v.phone;
      _emailCtrl.text   = v.email ?? '';
      _addressCtrl.text = v.address ?? '';
      _gstCtrl.text     = v.gstNumber ?? '';
      _notesCtrl.text   = v.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose(); _emailCtrl.dispose();
    _addressCtrl.dispose(); _gstCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Vendor' : 'Add Vendor',
            style: AurixTypography.headline2(AurixColors.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 100), children: [

          // Avatar preview
          Center(child: Container(width: 80, height: 80,
            decoration: BoxDecoration(gradient: AurixColors.goldGradient, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AurixColors.goldPrimary.withOpacity(0.4), blurRadius: 20)]),
            child: Center(child: Text(
              _nameCtrl.text.isEmpty ? '?' : _nameCtrl.text.substring(0,1).toUpperCase(),
              style: AurixTypography.display2(AurixColors.textOnGold))))),
          const SizedBox(height: 28),

          _label('Full Name *'),
          _field(_nameCtrl, 'e.g. Ravi Kumar', validator: (v) => v!.isEmpty ? 'Required' : null,
            onChanged: (_) => setState((){})),
          const SizedBox(height: 16),

          _label('Phone Number *'),
          _field(_phoneCtrl, '+91 9876543210',
            type: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Required' : v.length < 10 ? 'Invalid' : null),
          const SizedBox(height: 16),

          _label('Email (Optional)'),
          _field(_emailCtrl, 'vendor@email.com', type: TextInputType.emailAddress),
          const SizedBox(height: 16),

          _label('Address (Optional)'),
          _field(_addressCtrl, 'Shop address…', maxLines: 2),
          const SizedBox(height: 16),

          _label('GST Number (Optional)'),
          _field(_gstCtrl, 'e.g. 27XXXXX1234X1Z5'),
          const SizedBox(height: 16),

          _label('Notes (Optional)'),
          _field(_notesCtrl, 'Any additional info…', maxLines: 3),
          const SizedBox(height: 32),

          GoldButton(label: _isEdit ? 'Update Vendor' : 'Save Vendor',
            icon: Icons.save_rounded, isLoading: _saving, onTap: _save),
          const SizedBox(height: 12),
          GoldOutlinedButton(label: 'Cancel', onTap: () => context.pop()),
        ]),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AurixTypography.label(AurixColors.textSecondary)));

  Widget _field(TextEditingController ctrl, String hint, {
    TextInputType? type, int maxLines = 1,
    String? Function(String?)? validator, ValueChanged<String>? onChanged}) {
    return TextFormField(
      controller: ctrl, validator: validator, maxLines: maxLines,
      keyboardType: type, onChanged: onChanged,
      style: AurixTypography.body1(AurixColors.textPrimary),
      decoration: InputDecoration(hintText: hint),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final vendor = Vendor(
        id: _isEdit ? widget.vendor!.id : const Uuid().v4(),
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
        createdAt: _isEdit ? widget.vendor!.createdAt : DateTime.now(),
        totalCredit: _isEdit ? widget.vendor!.totalCredit : 0,
        totalDebit: _isEdit ? widget.vendor!.totalDebit : 0,
        gstNumber: _gstCtrl.text.trim().isEmpty ? null : _gstCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      if (_isEdit) {
        await ref.read(vendorListProvider.notifier).update(vendor);
      } else {
        await ref.read(vendorListProvider.notifier).add(vendor);
      }
      if (mounted) {
        showSuccessSnack(context, _isEdit ? 'Vendor updated!' : 'Vendor added!');
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
