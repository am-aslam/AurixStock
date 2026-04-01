import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../theme.dart';
import '../providers/providers.dart';
import '../core/constants/app_constants.dart';
import '../models/stock_entry.dart';
import '../models/vendor.dart';
import '../widgets/common/common_widgets.dart';

class AddEditStockScreen extends ConsumerStatefulWidget {
  final StockEntry? entry;
  const AddEditStockScreen({super.key, this.entry});

  @override
  ConsumerState<AddEditStockScreen> createState() => _AddEditStockScreenState();
}

class _AddEditStockScreenState extends ConsumerState<AddEditStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _priceCtrl  = TextEditingController();
  final _qtyCtrl    = TextEditingController(text: '1');
  final _notesCtrl  = TextEditingController();

  String _category = AppConstants.goldCategories.first;
  String _karat    = AppConstants.karatOptions[1];
  String _txType   = 'in';
  Vendor? _vendor;
  bool _saving = false;

  bool get _isEdit => widget.entry != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final e = widget.entry!;
      _nameCtrl.text   = e.name;
      _weightCtrl.text = e.weightGrams.toString();
      _priceCtrl.text  = e.pricePerGram.toString();
      _qtyCtrl.text    = e.quantity.toString();
      _notesCtrl.text  = e.notes ?? '';
      _category = e.category;
      _karat    = e.karat;
      _txType   = e.transactionType;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _weightCtrl.dispose(); _priceCtrl.dispose();
    _qtyCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorListProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AurixColors.bgPrimary,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Stock' : 'Add Stock',
            style: AurixTypography.headline2(AurixColors.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
      ),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 100), children: [

          // Transaction type toggle
          GlassCard(padding: const EdgeInsets.all(6), child: Row(children: [
            Expanded(child: _txToggle('Stock In', 'in', Icons.arrow_downward_rounded, AurixColors.credit)),
            Expanded(child: _txToggle('Stock Out', 'out', Icons.arrow_upward_rounded, AurixColors.debit)),
          ])),
          const SizedBox(height: 20),

          _label('Item Name'),
          _field(_nameCtrl, 'e.g. Gold Ring 22K', validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Category'),
              _dropdown(_category, AppConstants.goldCategories, (v) => setState(() => _category = v!)),
            ])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Karat'),
              _dropdown(_karat, AppConstants.karatOptions, (v) => setState(() => _karat = v!)),
            ])),
          ]),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Weight (grams)'),
              _field(_weightCtrl, '0.00', numeric: true, validator: (v) {
                if (v!.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Invalid';
                return null;
              }),
            ])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Price / gram (₹)'),
              _field(_priceCtrl, '0.00', numeric: true, validator: (v) {
                if (v!.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Invalid';
                return null;
              }),
            ])),
          ]),
          const SizedBox(height: 16),

          _label('Quantity'),
          _field(_qtyCtrl, '1', numeric: true, intOnly: true, validator: (v) {
            if (v!.isEmpty) return 'Required';
            if (int.tryParse(v) == null || int.parse(v) < 1) return 'Min 1';
            return null;
          }),
          const SizedBox(height: 16),

          // Live total
          _liveTotal(),
          const SizedBox(height: 16),

          _label('Vendor'),
          if (vendors.isEmpty)
            GlassCard(padding: const EdgeInsets.all(14), child: Row(children: [
              const Icon(Icons.warning_rounded, color: AurixColors.warning, size: 18),
              const SizedBox(width: 10),
              Text('Add a vendor first', style: AurixTypography.body2(AurixColors.textMuted)),
            ]))
          else
            _vendorDropdown(vendors),
          const SizedBox(height: 16),

          _label('Notes (Optional)'),
          _field(_notesCtrl, 'Any additional info…', maxLines: 3),
          const SizedBox(height: 32),

          GoldButton(label: _isEdit ? 'Update Entry' : 'Save Entry',
              icon: Icons.save_rounded, isLoading: _saving, onTap: _save),
          const SizedBox(height: 12),
          GoldOutlinedButton(label: 'Cancel', onTap: () => context.pop()),
        ]),
      ),
    );
  }

  Widget _txToggle(String label, String val, IconData icon, Color color) {
    final active = _txType == val;
    return GestureDetector(
      onTap: () => setState(() => _txType = val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? color : Colors.transparent, width: 1.5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: active ? color : AurixColors.textMuted, size: 18),
          const SizedBox(width: 6),
          Text(label, style: AurixTypography.label(active ? color : AurixColors.textMuted)),
        ]),
      ),
    );
  }

  Widget _liveTotal() {
    final w = double.tryParse(_weightCtrl.text) ?? 0;
    final p = double.tryParse(_priceCtrl.text) ?? 0;
    final q = int.tryParse(_qtyCtrl.text) ?? 0;
    final total = w * p * q;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: AurixColors.goldPrimary.withOpacity(0.3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Estimated Total', style: AurixTypography.body2(AurixColors.textMuted)),
        Text('₹${total.toStringAsFixed(2)}',
            style: AurixTypography.amountSmall(AurixColors.goldPrimary).copyWith(fontSize: 18)),
      ]),
    );
  }

  Widget _vendorDropdown(List<Vendor> vendors) {
    if (_vendor == null && widget.entry != null) {
      _vendor = vendors.where((v) => v.id == widget.entry!.vendorId).firstOrNull;
    }
    return Container(
      decoration: BoxDecoration(
        color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AurixColors.borderDivider)),
      child: DropdownButtonHideUnderline(child: DropdownButton<Vendor>(
        value: _vendor,
        isExpanded: true,
        dropdownColor: AurixColors.bgElevated,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        hint: Text('Select Vendor', style: AurixTypography.body2(AurixColors.textMuted)),
        icon: const Icon(Icons.expand_more_rounded, color: AurixColors.textMuted),
        items: vendors.map((v) => DropdownMenuItem(value: v,
          child: Text(v.name, style: AurixTypography.body1(AurixColors.textPrimary)))).toList(),
        onChanged: (v) => setState(() => _vendor = v),
      )),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AurixTypography.label(AurixColors.textSecondary)));

  Widget _dropdown(String value, List<String> items, ValueChanged<String?> onChanged) =>
    Container(
      decoration: BoxDecoration(color: AurixColors.bgElevated, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AurixColors.borderDivider)),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        value: value, isExpanded: true,
        dropdownColor: AurixColors.bgElevated,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        icon: const Icon(Icons.expand_more_rounded, color: AurixColors.textMuted),
        items: items.map((i) => DropdownMenuItem(value: i,
          child: Text(i, style: AurixTypography.body1(AurixColors.textPrimary)))).toList(),
        onChanged: onChanged,
      )),
    );

  Widget _field(TextEditingController ctrl, String hint, {
    bool numeric = false, bool intOnly = false,
    int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      maxLines: maxLines,
      keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      inputFormatters: intOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: AurixTypography.body1(AurixColors.textPrimary),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(hintText: hint),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_vendor == null) { showErrorSnack(context, 'Please select a vendor'); return; }
    setState(() => _saving = true);
    try {
      final entry = StockEntry(
        id: _isEdit ? widget.entry!.id : const Uuid().v4(),
        name: _nameCtrl.text.trim(),
        category: _category,
        karat: _karat,
        weightGrams: double.parse(_weightCtrl.text),
        pricePerGram: double.parse(_priceCtrl.text),
        quantity: int.parse(_qtyCtrl.text),
        vendorId: _vendor!.id,
        vendorName: _vendor!.name,
        createdAt: _isEdit ? widget.entry!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        transactionType: _txType,
        notes: _notesCtrl.text.trim(),
      );
      if (_isEdit) {
        await ref.read(stockListProvider.notifier).update(entry);
      } else {
        await ref.read(stockListProvider.notifier).add(entry);
      }
      if (mounted) {
        showSuccessSnack(context, _isEdit ? 'Stock updated!' : 'Stock added!');
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
