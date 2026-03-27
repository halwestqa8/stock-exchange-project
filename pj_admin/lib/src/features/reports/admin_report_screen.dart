import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_provider.dart';
import '../../core/dashboard_back_button.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

final adminReportsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await ref.read(apiClientProvider).getReports();
  return List<Map<String, dynamic>>.from(response.data['data'] ?? response.data);
});

class AdminReportScreen extends ConsumerWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final reportsAsync = ref.watch(adminReportsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const DashboardBackButton(),
        title: Text(L10n.of(context)!.reportOverview),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('هەموو ڕاپۆرتەکان', style: tt.labelLarge?.copyWith(color: AppTheme.ink, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Expanded(child: reportsAsync.when(
            data: (reports) => reports.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('📊', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(L10n.of(context)!.noReports, style: tt.titleMedium),
                ]))
              : ListView.separated(
                  itemCount: reports.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final r = reports[i];
                    final isOpen = r['status'] == 'open';
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: isOpen ? AppTheme.amberLight : AppTheme.tealLight, borderRadius: BorderRadius.circular(100)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: isOpen ? AppTheme.amber : AppTheme.teal)),
                              const SizedBox(width: 5),
                              Text(isOpen ? L10n.of(context)!.open.toUpperCase() : L10n.of(context)!.resolved.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isOpen ? const Color(0xFF92400E) : const Color(0xFF065F46))),
                            ]),
                          ),
                          const SizedBox(width: 12),
                          Text('${L10n.of(context)!.reportLabel} #${r['id']}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.ink)),
                          const Spacer(),
                          Text('${L10n.of(context)!.shipmentLabel}: #${(r['shipment_id'] as String).substring(0, 8)}', style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
                        ]),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10)),
                          child: Text(r['customer_comment'] ?? '', style: const TextStyle(fontSize: 13, color: AppTheme.ink, height: 1.5)),
                        ),
                        if (!isOpen && r['staff_response'] != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(10)),
                            child: Text('${L10n.of(context)!.staffResponse}: ${r['staff_response']}', style: const TextStyle(fontSize: 13, color: Color(0xFF065F46), height: 1.5)),
                          ),
                        ],
                      ]),
                    );
                  },
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('${L10n.of(context)!.error}: $e')),
          )),
        ]),
      ),
    );
  }
}
