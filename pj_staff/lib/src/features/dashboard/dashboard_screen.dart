import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

import '../../core/api_provider.dart';
import '../../core/theme.dart';
import '../shell/staff_shell.dart';

final staffShipmentsProvider = FutureProvider<List<Shipment>>((ref) async {
  final response = await ref.read(apiClientProvider).getShipments();
  final List data = response.data['data'];
  return data.map((json) => Shipment.fromJson(json)).toList();
});

final allDriversProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await ref.read(apiClientProvider).getDrivers();
  return response.data as List<dynamic>;
});

class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final l10n = L10n.of(context)!;
    final locale = ref.watch(localeProvider);
    final shipmentsAsync = ref.watch(staffShipmentsProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final pagePadding = EdgeInsets.all(isCompact ? 16 : 28);

    return StaffShell(
      activeRoute: '/',
      title: l10n.dashboard,
      actions: [
        IconButton(
          onPressed: () => ref.read(localeProvider.notifier).toggle(),
          tooltip: locale.languageCode == 'en' ? l10n.kurdish : l10n.english,
          icon: const Icon(Icons.language_rounded),
        ),
        IconButton(
          onPressed: () => ref.refresh(staffShipmentsProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.shipmentMonitor, style: tt.headlineLarge),
                        const SizedBox(height: 6),
                        Text(
                          l10n.monitorSubtitle,
                          style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => ref.read(localeProvider.notifier).toggle(),
                    icon: const Text(
                      '\u{1F310}',
                      style: TextStyle(fontSize: 16),
                    ),
                    label: Text(
                      locale.languageCode == 'en' ? l10n.kurdish : l10n.english,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(staffShipmentsProvider),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(l10n.refresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.shipmentMonitor, style: tt.headlineSmall),
              const SizedBox(height: 6),
              Text(
                l10n.monitorSubtitle,
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 16),
            ],
            shipmentsAsync.when(
              data: (shipments) {
                final pending = shipments
                    .where((s) => s.status == ShipmentStatus.pending)
                    .length;
                final transit = shipments
                    .where((s) => s.status == ShipmentStatus.inTransit)
                    .length;
                final delivered = shipments
                    .where((s) => s.status == ShipmentStatus.delivered)
                    .length;
                final stats = [
                  (
                    label: l10n.total,
                    value: '${shipments.length}',
                    emoji: '\u{1F4E6}',
                    bg: AppTheme.indigoLight,
                  ),
                  (
                    label: l10n.pendingCount,
                    value: '$pending',
                    emoji: '\u{231B}',
                    bg: AppTheme.amberLight,
                  ),
                  (
                    label: l10n.inTransitCount,
                    value: '$transit',
                    emoji: '\u{1F69B}',
                    bg: AppTheme.blueLight,
                  ),
                  (
                    label: l10n.deliveredCount,
                    value: '$delivered',
                    emoji: '\u{2705}',
                    bg: AppTheme.tealLight,
                  ),
                ];

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (isCompact) {
                      final itemWidth = constraints.maxWidth > 520
                          ? (constraints.maxWidth - 12) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final stat in stats)
                            SizedBox(
                              width: itemWidth,
                              child: _statCard(
                                stat.label,
                                stat.value,
                                stat.emoji,
                                stat.bg,
                              ),
                            ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        for (var i = 0; i < stats.length; i++) ...[
                          Expanded(
                            child: _statCard(
                              stats[i].label,
                              stats[i].value,
                              stats[i].emoji,
                              stats[i].bg,
                            ),
                          ),
                          if (i < stats.length - 1) const SizedBox(width: 12),
                        ],
                      ],
                    );
                  },
                );
              },
              loading: () => const SizedBox(),
              error: (_, _) => const SizedBox(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: shipmentsAsync.when(
                  data: (shipments) => ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tableWidth = constraints.maxWidth < 760
                            ? 760.0
                            : constraints.maxWidth;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: tableWidth,
                            child: DataTable2(
                              columnSpacing: 12,
                              horizontalMargin: 20,
                              minWidth: 600,
                              headingRowHeight: 48,
                              dataRowHeight: 56,
                              headingTextStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.muted,
                                letterSpacing: 0.5,
                              ),
                              dataTextStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppTheme.ink,
                              ),
                              columns: [
                                DataColumn2(
                                  label: Text(l10n.id),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text(l10n.route.toUpperCase()),
                                ),
                                DataColumn2(
                                  label: Text(
                                    l10n.weight.toUpperCase().split(' ')[0],
                                  ),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text(l10n.driverLabel),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text(
                                    l10n.shipmentStatus.toUpperCase(),
                                  ),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text(l10n.actionLabel),
                                  size: ColumnSize.S,
                                ),
                              ],
                              rows: shipments.map((s) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        '#${s.id.substring(0, 12)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${s.origin} \u{2192} ${s.destination}',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        s.weightKg != null
                                            ? l10n.kgUnit(
                                                s.weightKg!.toStringAsFixed(0),
                                              )
                                            : (s.size ?? '--'),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        s.driverId != null
                                            ? 'Driver #${s.driverId}'
                                            : '\u2014',
                                        style: TextStyle(
                                          color: s.driverId == null
                                              ? AppTheme.muted
                                              : AppTheme.ink,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      StatusBadge(
                                        status: s.status,
                                        label: switch (s.status) {
                                          ShipmentStatus.pending =>
                                            l10n.pending,
                                          ShipmentStatus.inTransit =>
                                            l10n.inTransit,
                                          ShipmentStatus.delivered =>
                                            l10n.delivered,
                                          ShipmentStatus.reported =>
                                            l10n.reported,
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      s.driverId == null
                                          ? TextButton(
                                              onPressed: () => _assignDriver(
                                                context,
                                                ref,
                                                s.id,
                                              ),
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AppTheme.indigo,
                                                textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              child: Text(l10n.assignBtn),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('${l10n.error}: $e')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, String emoji, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withAlpha(100)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.ink,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _assignDriver(BuildContext context, WidgetRef ref, String shipmentId) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = L10n.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(l10n.assignDriverTitle),
          content: SizedBox(
            width: 400,
            height: 300,
            child: Consumer(
              builder: (context, ref, _) {
                final driversAsync = ref.watch(allDriversProvider);
                return driversAsync.when(
                  data: (drivers) {
                    if (drivers.isEmpty) {
                      return Center(child: Text(l10n.noDriversFound));
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: drivers.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final d = drivers[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.indigo.withAlpha(30),
                            child: Text(
                              d['name'][0].toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            d['name'],
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            d['email'],
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            try {
                              await ref
                                  .read(apiClientProvider)
                                  .assignDriver(shipmentId, d['id']);
                              if (ctx.mounted) {
                                Navigator.pop(ctx);
                                ref.invalidate(staffShipmentsProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.statusUpdated('assigned'),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${l10n.error}: $e'),
                                    backgroundColor: AppTheme.red,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('${l10n.error}: $e')),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}
