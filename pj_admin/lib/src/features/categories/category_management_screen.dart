import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';

final adminCategoryListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminCategories();
  return extractMapList(response.data);
});

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final categoriesAsync = ref.watch(adminCategoryListProvider);

    return AdminShell(
      activeRoute: '/categories',
      title: l10n.categories,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminCategoryListProvider),
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
              Text(l10n.categories, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Active shipment categories and their surcharge rules.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.categories, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.categoryCrudPlaceholder,
                        style: tt.titleMedium?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final title = l10n.localeName == 'ku'
                          ? (category['name_ku'] ?? category['name_en'] ?? '')
                          : (category['name_en'] ?? '');

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
                                    'English: ${category['name_en'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _surchargeChip(category['surcharge']),
                                ],
                              )
                            : Row(
                                children: [
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
                                          'EN: ${category['name_en'] ?? ''}  •  KU: ${category['name_ku'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _surchargeChip(category['surcharge']),
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

  Widget _surchargeChip(dynamic surcharge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.amberLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '+\$${surcharge ?? 0}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF92400E),
        ),
      ),
    );
  }
}
