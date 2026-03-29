import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';

final adminVehicleTypesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminVehicles();
  return extractMapList(response.data);
});

class VehicleManagementScreen extends ConsumerWidget {
  const VehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final vehiclesAsync = ref.watch(adminVehicleTypesProvider);

    return AdminShell(
      activeRoute: '/vehicles',
      title: l10n.vehicleTypes,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminVehicleTypesProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.vehicleTypes, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Delivery vehicles, multipliers, and time offsets.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.vehicleTypes, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: vehiclesAsync.when(
                data: (vehicles) {
                  if (vehicles.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.vehicleCrudPlaceholder,
                        style: tt.titleMedium?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: vehicles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      final title = l10n.localeName == 'ku'
                          ? (vehicle['name_ku'] ?? vehicle['name_en'] ?? '')
                          : (vehicle['name_en'] ?? '');
                      final emoji = switch (vehicle['name_en']
                          ?.toString()
                          .toLowerCase()) {
                        'truck' => '🚛',
                        'van' => '🚐',
                        'air cargo' || 'air' => '✈️',
                        'motorcycle' => '🏍️',
                        _ => '🚗',
                      };

                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: isCompact
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 26),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.ink,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _chip(
                                        '×${vehicle['multiplier']}',
                                        AppTheme.tealLight,
                                        const Color(0xFF065F46),
                                      ),
                                      _chip(
                                        '${vehicle['delivery_days_offset'] >= 0 ? '+' : ''}${vehicle['delivery_days_offset']}d',
                                        AppTheme.blueLight,
                                        const Color(0xFF1D4ED8),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.ink,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'EN: ${vehicle['name_en'] ?? ''}  •  KU: ${vehicle['name_ku'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _chip(
                                    '×${vehicle['multiplier']}',
                                    AppTheme.tealLight,
                                    const Color(0xFF065F46),
                                  ),
                                  const SizedBox(width: 8),
                                  _chip(
                                    '${vehicle['delivery_days_offset'] >= 0 ? '+' : ''}${vehicle['delivery_days_offset']}d',
                                    AppTheme.blueLight,
                                    const Color(0xFF1D4ED8),
                                  ),
                                ],
                              ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('${l10n.error}: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
