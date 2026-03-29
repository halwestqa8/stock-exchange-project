import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';

final adminFaqsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminFaqs();
  return extractMapList(response.data);
});

class FaqManagementScreen extends ConsumerWidget {
  const FaqManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final faqsAsync = ref.watch(adminFaqsProvider);

    return AdminShell(
      activeRoute: '/faq',
      title: l10n.faqManagement,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminFaqsProvider),
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
              Text(l10n.faqManagement, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Frequently asked questions currently published in the system.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.faqManagement, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: faqsAsync.when(
                data: (faqs) {
                  if (faqs.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.faqCrudPlaceholder,
                        style: tt.titleMedium?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: faqs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final faq = faqs[index];
                      final question = l10n.localeName == 'ku'
                          ? (faq['question_ku'] ?? faq['question_en'] ?? '')
                          : (faq['question_en'] ?? '');
                      final answer = l10n.localeName == 'ku'
                          ? (faq['answer_ku'] ?? faq['answer_en'] ?? '')
                          : (faq['answer_en'] ?? '');

                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppTheme.roseLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.quiz_rounded,
                                    color: AppTheme.rose,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.ink,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.blueLight,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '#${faq['sort_order'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              answer,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.ink,
                                height: 1.5,
                              ),
                            ),
                            if (!isCompact) ...[
                              const SizedBox(height: 12),
                              Text(
                                'EN: ${faq['question_en'] ?? ''}\nKU: ${faq['question_ku'] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted,
                                  height: 1.4,
                                ),
                              ),
                            ],
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
}
