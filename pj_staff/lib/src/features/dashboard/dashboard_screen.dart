import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';

import '../shell/staff_sidebar.dart';
import 'package:pj_l10n/pj_l10n.dart';

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
    final shipmentsAsync = ref.watch(staffShipmentsProvider);

    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ──
          const StaffSidebar(activeRoute: '/'),

          // ── Main Content ──
          Expanded(child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Row(children: [
                Text(L10n.of(context)!.shipmentMonitor, style: tt.headlineLarge),
                const Spacer(),
                Consumer(
                  builder: (context, ref, _) {
                    final locale = ref.watch(localeProvider);
                    return TextButton.icon(
                      onPressed: () => ref.read(localeProvider.notifier).toggle(),
                      icon: const Text('\u{1F310}', style: TextStyle(fontSize: 16)), // Globe 🌐
                      label: Text(
                        locale.languageCode == 'en' ? L10n.of(context)!.kurdish : L10n.of(context)!.english,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () { final _ = ref.refresh(staffShipmentsProvider); },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(L10n.of(context)!.refresh),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.indigo),
                ),
              ]),
              const SizedBox(height: 6),
              Text(L10n.of(context)!.monitorSubtitle, style: tt.bodyMedium?.copyWith(color: AppTheme.muted)),
              const SizedBox(height: 20),

              // Stats Row
              shipmentsAsync.when(
                data: (shipments) {
                  final pending = shipments.where((s) => s.status == ShipmentStatus.pending).length;
                  final transit = shipments.where((s) => s.status == ShipmentStatus.inTransit).length;
                  final delivered = shipments.where((s) => s.status == ShipmentStatus.delivered).length;
                  return Row(children: [
                    _statCard(L10n.of(context)!.total, '${shipments.length}', '\u{1F4E6}', AppTheme.indigoLight), // Package 📦
                    const SizedBox(width: 12),
                    _statCard(L10n.of(context)!.pendingCount, '$pending', '\u{231B}', AppTheme.amberLight), // Hourglass ⌛
                    const SizedBox(width: 12),
                    _statCard(L10n.of(context)!.inTransitCount, '$transit', '\u{1F69B}', AppTheme.blueLight), // Truck 🚚
                    const SizedBox(width: 12),
                    _statCard(L10n.of(context)!.deliveredCount, '$delivered', '\u{2705}', AppTheme.tealLight), // Check ✅
                  ]);
                },
                loading: () => const SizedBox(),
                error: (_, _) => const SizedBox(),
              ),
              const SizedBox(height: 20),

              // Table
              Expanded(child: Container(
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
                child: shipmentsAsync.when(
                  data: (shipments) => ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: DataTable2(
                      columnSpacing: 12, horizontalMargin: 20, minWidth: 600, headingRowHeight: 48, dataRowHeight: 56,
                      headingTextStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.muted, letterSpacing: 0.5),
                      dataTextStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.ink),
                      columns: [
                        DataColumn2(label: Text(L10n.of(context)!.id), size: ColumnSize.S),
                        DataColumn2(label: Text(L10n.of(context)!.route.toUpperCase())),
                        DataColumn2(label: Text(L10n.of(context)!.weight.toUpperCase().split(' ')[0]), size: ColumnSize.S),
                        DataColumn2(label: Text(L10n.of(context)!.driverLabel), size: ColumnSize.S),
                        DataColumn2(label: Text(L10n.of(context)!.shipmentStatus.toUpperCase()), size: ColumnSize.S),
                        DataColumn2(label: Text(L10n.of(context)!.actionLabel), size: ColumnSize.S),
                      ],
                      rows: shipments.map((s) => DataRow(cells: [
                        DataCell(Text('#${s.id.substring(0, 12)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                        DataCell(Text('${s.origin} \u{2192} ${s.destination}')), // Arrow →
                        DataCell(Text(s.weightKg != null ? L10n.of(context)!.kgUnit(s.weightKg!.toStringAsFixed(0)) : (s.size ?? '--'))),
                        DataCell(Text(s.driverId != null ? 'شۆفێر #${s.driverId}' : '—', style: TextStyle(color: s.driverId == null ? AppTheme.muted : AppTheme.ink))),
                        DataCell(StatusBadge(
                          status: s.status,
                          label: switch (s.status) {
                            ShipmentStatus.pending => L10n.of(context)!.pending,
                            ShipmentStatus.inTransit => L10n.of(context)!.inTransit,
                            ShipmentStatus.delivered => L10n.of(context)!.delivered,
                            ShipmentStatus.reported => L10n.of(context)!.reported,
                          },
                        )),
                        DataCell(s.driverId == null
                          ? TextButton(
                              onPressed: () => _assignDriver(context, ref, s.id),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.indigo, textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                              child: Text(L10n.of(context)!.assignBtn))
                          : const SizedBox()),
                      ])).toList(),
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('${L10n.of(context)!.error}: $e')),
                ),
              )),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, String emoji, Color bg) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border.withAlpha(100))),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.ink)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.muted, fontWeight: FontWeight.w600)),
        ]),
      ]),
    ));
  }

  void _assignDriver(BuildContext context, WidgetRef ref, String shipmentId) {
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(L10n.of(context)!.assignDriverTitle),
        content: SizedBox(
          width: 400,
          height: 300,
          child: Consumer(builder: (context, ref, _) {
            final driversAsync = ref.watch(allDriversProvider);
            return driversAsync.when(
              data: (drivers) {
                if (drivers.isEmpty) return Center(child: Text(L10n.of(context)!.noDriversFound));
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: drivers.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final d = drivers[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.indigo.withAlpha(30),
                        child: Text(d['name'][0].toUpperCase(), style: const TextStyle(color: AppTheme.indigo, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(d['name'], style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(d['email'], style: const TextStyle(fontSize: 11)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () async {
                        try {
                          await ref.read(apiClientProvider).assignDriver(shipmentId, d['id']);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ref.invalidate(staffShipmentsProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(L10n.of(context)!.statusUpdated('assigned'))),
                            );
                          }
                        } catch (e) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${L10n.of(context)!.error}: $e'), backgroundColor: AppTheme.red),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${L10n.of(context)!.error}: $e')),
            );
          }),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(L10n.of(context)!.cancel)),
        ],
      );
    });
  }
}
