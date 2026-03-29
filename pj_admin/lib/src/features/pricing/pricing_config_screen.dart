import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';

final pricingProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final response = await ref.read(apiClientProvider).getAdminPricing();
  return extractMapBody(response.data);
});

class PricingConfigScreen extends ConsumerStatefulWidget {
  const PricingConfigScreen({super.key});

  @override
  ConsumerState<PricingConfigScreen> createState() =>
      _PricingConfigScreenState();
}

class _PricingConfigScreenState extends ConsumerState<PricingConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _basePriceCtrl = TextEditingController();
  final _weightRateCtrl = TextEditingController();

  bool _isSaving = false;
  bool _hasInitializedForm = false;
  double? _initialBasePrice;
  double? _initialWeightRate;

  @override
  void initState() {
    super.initState();
    _basePriceCtrl.addListener(_onFieldChanged);
    _weightRateCtrl.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _basePriceCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    _weightRateCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _applyConfig(Map<String, dynamic> config) {
    final basePrice = _parseStoredNumber(config['base_price']) ?? 0;
    final weightRate = _parseStoredNumber(config['weight_rate']) ?? 0;

    _initialBasePrice = basePrice;
    _initialWeightRate = weightRate;
    _basePriceCtrl.text = _formatNumber(basePrice);
    _weightRateCtrl.text = _formatNumber(weightRate);
    _hasInitializedForm = true;
  }

  double? _parseStoredNumber(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  double? _parseFieldValue(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  String _formatNumber(num value) {
    final asText = value.toString();
    return asText.endsWith('.0')
        ? asText.substring(0, asText.length - 2)
        : asText;
  }

  String _screenText(
    BuildContext context, {
    required String ku,
    required String en,
  }) {
    return L10n.of(context)!.localeName == 'ku' ? ku : en;
  }

  String? _validatePriceField(BuildContext context, String? value) {
    final l10n = L10n.of(context)!;
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.required;
    if (_parseFieldValue(trimmed) == null) {
      return _screenText(
        context,
        ku: 'تکایە ژمارەیەکی دروست بنووسە',
        en: 'Please enter a valid number',
      );
    }
    return null;
  }

  bool get _isDirty {
    final currentBasePrice = _parseFieldValue(_basePriceCtrl.text);
    final currentWeightRate = _parseFieldValue(_weightRateCtrl.text);
    if (currentBasePrice == null || currentWeightRate == null) return false;
    return currentBasePrice != _initialBasePrice ||
        currentWeightRate != _initialWeightRate;
  }

  Future<void> _resetForm() async {
    if (_initialBasePrice == null || _initialWeightRate == null) return;
    _basePriceCtrl.text = _formatNumber(_initialBasePrice!);
    _weightRateCtrl.text = _formatNumber(_initialWeightRate!);
  }

  Future<void> _savePricing() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = L10n.of(context)!;
    final basePrice = _parseFieldValue(_basePriceCtrl.text);
    final weightRate = _parseFieldValue(_weightRateCtrl.text);
    if (basePrice == null || weightRate == null) return;

    setState(() => _isSaving = true);

    try {
      final response = await ref.read(apiClientProvider).updateAdminPricing({
        'base_price': basePrice,
        'weight_rate': weightRate,
      });

      final savedConfig = extractMapBody(response.data);
      if (mounted) {
        setState(() {
          _applyConfig(savedConfig);
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('${l10n.success}: ${l10n.updatePricing}')),
          );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('${l10n.error}: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final pricingAsync = ref.watch(pricingProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/pricing',
      title: l10n.pricingConfiguration,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(pricingProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: pricingAsync.when(
        data: (config) {
          if (!_hasInitializedForm) {
            _applyConfig(config);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isCompact ? 16 : 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCompact) ...[
                      Text(
                        l10n.pricingConfiguration,
                        style: textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update the default pricing formula used for shipments.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      Text(
                        l10n.pricingConfiguration,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      _screenText(
                        context,
                        ku: 'نرخی ئێستا',
                        en: 'Current pricing',
                      ),
                      style: textTheme.labelLarge?.copyWith(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PricingField(
                              controller: _basePriceCtrl,
                              label: l10n.basePrice,
                              helperText: _screenText(
                                context,
                                ku: 'نرخی سەرەکی بۆ هەر بارێک',
                                en: 'Starting price for every shipment',
                              ),
                              prefixIcon: Icons.attach_money_rounded,
                              suffixText: 'USD',
                              validator: (value) =>
                                  _validatePriceField(context, value),
                            ),
                            const SizedBox(height: 18),
                            _PricingField(
                              controller: _weightRateCtrl,
                              label: l10n.weightRate,
                              helperText: _screenText(
                                context,
                                ku: 'زیادبوونی نرخ بەپێی کێش',
                                en: 'Additional charge per kilogram',
                              ),
                              prefixIcon: Icons.scale_rounded,
                              suffixText: '/kg',
                              validator: (value) =>
                                  _validatePriceField(context, value),
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                OutlinedButton(
                                  onPressed: _isSaving || !_isDirty
                                      ? null
                                      : _resetForm,
                                  child: Text(l10n.cancel),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _isSaving || !_isDirty
                                      ? null
                                      : _savePricing,
                                  icon: _isSaving
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save_rounded),
                                  label: Text(l10n.updatePricing),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow(
                            icon: Icons.payments_rounded,
                            iconColor: AppTheme.teal,
                            label: l10n.basePrice,
                            value: '\$${_basePriceCtrl.text}',
                          ),
                          const Divider(height: 28),
                          _SummaryRow(
                            icon: Icons.monitor_weight_outlined,
                            iconColor: AppTheme.blue,
                            label: l10n.weightRate,
                            value: '\$${_weightRateCtrl.text} /kg',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.blueLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFF1E40AF),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.pricingFormula,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('${L10n.of(context)!.error}: $error')),
      ),
    );
  }
}

class _PricingField extends StatelessWidget {
  const _PricingField({
    required this.controller,
    required this.label,
    required this.helperText,
    required this.prefixIcon,
    required this.suffixText,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String helperText;
  final IconData prefixIcon;
  final String suffixText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppTheme.ink),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: InputDecoration(
            helperText: helperText,
            prefixIcon: Icon(prefixIcon),
            suffixText: suffixText,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.ink,
          ),
        ),
      ],
    );
  }
}
