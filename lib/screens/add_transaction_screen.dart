import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../core/constants/app_constants.dart';
import '../models/transaction.dart';
import '../models/vendor.dart';
import '../widgets/common/common_widgets.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});
  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _amountCtrl= TextEditingController();
  final _descCtrl  = TextEditingController();
  final _refCtrl   = TextEditingController();

  String  _type    = 'credit';
  String  _mode    = AppConstants.paymentModes.first;
  Vendor? _vendor;
  DateTime _date   = DateTime.now();
  bool    _saving  = false;

  @override
  void dispose() { _amountCtrl.dispose(); _descCtrl.dispose(); _refCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorListProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      appBar: AppBar(
        title: Text('Add Transaction', style: AurixTypography.headline2(AurixColors.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      body: Form(key: _formKey,
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 100), children: [

          // Type toggle
          GlassCard(padding: const EdgeInsets.all(6), child: Row(children: [
            Expanded(child: _txToggle('Credit', 'credit', Icons.add_circle_rounded, AurixColors.credit)),
            Expanded(child: _txToggle('Debit',  'debit',  Icons.remove_circle_rounded, AurixColors.debit)),
          ])),
          const SizedBox(height: 20),

          _label('Amount (₹) *'),
          TextFormField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            style: AurixTypography.body1(AurixColors.textPrimary),
            validator: (v) => v!.isEmpty ? 'Required' : double.tryParse(v) == null ? 'Invalid' : null,
            decoration: const InputDecoration(hintText: '0.00', prefixIcon: Icon(Icons.currency_rupee_rounded)),
          ),
          const SizedBox(height: 16),

          _label('Vendor *'),
          if (vendors.isEmpty)
            GlassCard(padding: const EdgeInsets.all(14), child: Row(children: [
              const Icon(Icons.warning_rounded, color: AurixColors.warning, size: 18),
              const SizedBox(width: 10),
              Text('Add a vendor first', style: AurixTypography.body2(AurixColors.textMuted)),
            ]))
          else _vendorPicker(vendors),
          const SizedBox(height: 16),

          _label('Payment Mode *'),
          _dropdown(_mode, AppConstants.paymentModes, (v) => setState(() => _mode = v!)),
          const SizedBox(height: 16),

          _label('Date'),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AurixColors.borderDivider)),
              child: Row(children: [
                const Icon(Icons.calendar_today_rounded, color: AurixColors.textMuted, size: 18),
                const SizedBox(width: 12),
                Text('${_date.day}/${_date.month}/${_date.year}',
                  style: AurixTypography.body1(AurixColors.textPrimary)),
                const Spacer(),
                const Icon(Icons.expand_more_rounded, color: AurixColors.textMuted),
              ]),
            )),
          const SizedBox(height: 16),

          _label('Reference Number (Optional)'),
          TextFormField(controller: _refCtrl,
            style: AurixTypography.body1(AurixColors.textPrimary),
            decoration: const InputDecoration(hintText: 'Cheque/UPI ref…',
              prefixIcon: Icon(Icons.tag_rounded))),
          const SizedBox(height: 16),

          _label('Description (Optional)'),
          TextFormField(controller: _descCtrl, maxLines: 3,
            style: AurixTypography.body1(AurixColors.textPrimary),
            decoration: const InputDecoration(hintText: 'What is this for?')),
          const SizedBox(height: 32),

          GoldButton(label: 'Save Transaction', icon: Icons.save_rounded, isLoading: _saving, onTap: _save),
          const SizedBox(height: 12),
          GoldOutlinedButton(label: 'Cancel', onTap: () => context.pop()),
        ]),
      ),
    );
  }

  Widget _txToggle(String label, String val, IconData icon, Color color) {
    final active = _type == val;
    return GestureDetector(
      onTap: () => setState(() => _type = val),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? color : Colors.transparent, width: 1.5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: active ? color : AurixColors.textMuted, size: 18),
          const SizedBox(width: 6),
          Text(label, style: AurixTypography.label(active ? color : AurixColors.textMuted)),
        ])));
  }

  Widget _vendorPicker(List<Vendor> vendors) => Container(
    decoration: BoxDecoration(color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AurixColors.borderDivider)),
    child: DropdownButtonHideUnderline(child: DropdownButton<Vendor>(
      value: _vendor, isExpanded: true, dropdownColor: AurixColors.bgElevated,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      hint: Text('Select Vendor', style: AurixTypography.body2(AurixColors.textMuted)),
      icon: const Icon(Icons.expand_more_rounded, color: AurixColors.textMuted),
      items: vendors.map((v) => DropdownMenuItem(value: v,
        child: Text(v.name, style: AurixTypography.body1(AurixColors.textPrimary)))).toList(),
      onChanged: (v) => setState(() => _vendor = v),
    )));

  Widget _dropdown(String value, List<String> items, ValueChanged<String?> onChange) =>
    Container(
      decoration: BoxDecoration(color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AurixColors.borderDivider)),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        value: value, isExpanded: true, dropdownColor: AurixColors.bgElevated,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        icon: const Icon(Icons.expand_more_rounded, color: AurixColors.textMuted),
        items: items.map((i) => DropdownMenuItem(value: i,
          child: Text(i, style: AurixTypography.body1(AurixColors.textPrimary)))).toList(),
        onChanged: onChange,
      )));

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AurixTypography.label(AurixColors.textSecondary)));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _date,
      firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(
        colorScheme: const ColorScheme.dark(primary: AurixColors.goldPrimary,
          surface: AurixColors.bgElevated, onSurface: AurixColors.textPrimary)), child: child!));
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_vendor == null) { showErrorSnack(context, 'Select a vendor'); return; }
    setState(() => _saving = true);
    try {
      final tx = Transaction(
        id: const Uuid().v4(),
        vendorId: _vendor!.id,
        vendorName: _vendor!.name,
        type: _type,
        amount: double.parse(_amountCtrl.text),
        date: _date,
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        paymentMode: _mode,
        referenceNumber: _refCtrl.text.trim().isEmpty ? null : _refCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
      await ref.read(transactionListProvider.notifier).add(tx);
      await ref.read(vendorListProvider.notifier).updateBalance(_vendor!.id, _type, tx.amount);
      if (mounted) { showSuccessSnack(context, 'Transaction saved!'); context.pop(); }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
