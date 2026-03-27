import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/theme.dart';
import 'shipment_provider.dart';
import 'package:pj_l10n/pj_l10n.dart';

final _selectedFilterProvider = StateProvider<String>((ref) => 'All');

class ShipmentListScreen extends ConsumerStatefulWidget {
  const ShipmentListScreen({super.key});

  @override
  ConsumerState<ShipmentListScreen> createState() =>
      _ShipmentListScreenState();
}

class _ShipmentListScreenState extends ConsumerState<ShipmentListScreen>
    with SingleTickerProviderStateMixin {
  // ── Entrance controller for header elements ───────────────────────────────
  late final AnimationController _entranceCtrl;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerOpacity;

  late final Animation<Offset> _filterSlide;
  late final Animation<double> _filterOpacity;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
    ));
    _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.45, curve: Curves.easeOut),
      ),
    );

    _filterSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.20, 0.70, curve: Curves.easeOutCubic),
    ));
    _filterOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final shipmentsAsync = ref.watch(customerShipmentsProvider);
    final selectedFilter = ref.watch(_selectedFilterProvider);

    final l10n = L10n.of(context)!;
    final filters = [l10n.all, l10n.pending, l10n.inTransit, l10n.delivered, l10n.reported];

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            AnimatedBuilder(
              animation: _entranceCtrl,
              builder: (_, child) => SlideTransition(
                position: _headerSlide,
                child: FadeTransition(opacity: _headerOpacity, child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(L10n.of(context)!.myShipments, style: tt.displaySmall),
                          const SizedBox(height: 2),
                          shipmentsAsync.when(
                            data: (list) {
                              final filtered =
                                  _applyFilter(list, selectedFilter);
                              return Text(
                                filtered.length == 1 ? l10n.shipmentCount(filtered.length) : l10n.shipmentsCount(filtered.length),
                                style: tt.bodySmall,
                              );
                            },
                            loading: () =>
                                Text(L10n.of(context)!.loading, style: tt.bodySmall),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    // New shipment FAB-style button
                    _NewShipmentButton(
                      onTap: () => context.push('/create-shipment'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Filter Chips ──
            AnimatedBuilder(
              animation: _entranceCtrl,
              builder: (_, child) => SlideTransition(
                position: _filterSlide,
                child:
                    FadeTransition(opacity: _filterOpacity, child: child),
              ),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final filter = filters[i];
                    final isActive = selectedFilter == filter;
                    return _FilterChip(
                      label: filter,
                      isActive: isActive,
                      onTap: () => ref
                          .read(_selectedFilterProvider.notifier)
                          .state = filter,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Shipment List ──
            Expanded(
              child: shipmentsAsync.when(
                data: (shipments) {
                  final filtered = _applyFilter(shipments, selectedFilter);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedFilter == l10n.all ? '\u{1F4E6}' : _filterEmoji(selectedFilter), // Package 📦
                            style: const TextStyle(fontSize: 44),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedFilter == l10n.all
                                ? l10n.noShipmentsYet
                                : '${l10n.noShipmentsFilter}: $selectedFilter',
                            style: tt.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedFilter == l10n.all
                                ? l10n.createFirstShipment
                                : l10n.tryDifferentFilter,
                            style: tt.bodySmall,
                          ),
                          if (selectedFilter == l10n.all) ...[
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                onPressed: () => context.push('/create-shipment'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.teal,
                                  minimumSize: const Size(0, 44),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text('+ ${L10n.of(context)!.newShipment}'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(customerShipmentsProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final s = filtered[i];
                        return _StaggeredListItem(
                          index: i,
                          child: _ShipmentCard(
                            shipment: s,
                            onTap: () =>
                                context.push('/shipments/${s.id}'),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 36)),
                      const SizedBox(height: 10),
                      Text(l10n.failedToLoadShipments, style: tt.titleMedium),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => ref.refresh(customerShipmentsProvider.future),
                        child: Text(L10n.of(context)!.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Shipment> _applyFilter(List<Shipment> shipments, String filter) {
    final l10n = L10n.of(context)!;
    if (filter == l10n.pending) return shipments.where((s) => s.status == ShipmentStatus.pending).toList();
    if (filter == l10n.inTransit) return shipments.where((s) => s.status == ShipmentStatus.inTransit).toList();
    if (filter == l10n.delivered) return shipments.where((s) => s.status == ShipmentStatus.delivered).toList();
    if (filter == l10n.reported) return shipments.where((s) => s.status == ShipmentStatus.reported).toList();
    return shipments;
  }

  String _filterEmoji(String filter) {
    final l10n = L10n.of(context)!;
    if (filter == l10n.pending) return '\u{231B}'; // Hourglass ⌛
    if (filter == l10n.inTransit) return '\u{1F69B}'; // Truck 🚚
    if (filter == l10n.delivered) return '\u{2705}'; // Check ✅
    if (filter == l10n.reported) return '\u{26A0}'; // Warning ⚠️
    return '\u{1F4E6}'; // Package 📦
  }
}

// ── Staggered list item ────────────────────────────────────────────────────────

class _StaggeredListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredListItem({required this.index, required this.child});

  @override
  State<_StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<_StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    final delay = Duration(milliseconds: 60 + widget.index * 55);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.45),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );
    Future.delayed(delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => SlideTransition(
        position: _slide,
        child: FadeTransition(opacity: _opacity, child: child),
      ),
      child: widget.child,
    );
  }
}

// ── Animated filter chip ───────────────────────────────────────────────────────

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: widget.isActive ? AppTheme.ink : AppTheme.card,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: widget.isActive ? AppTheme.ink : AppTheme.border,
              width: 1.5,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppTheme.ink.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.isActive ? Colors.white : AppTheme.muted,
            ),
          ),
        ),
      ),
    );
  }
}

// ── New Shipment button ────────────────────────────────────────────────────────

class _NewShipmentButton extends StatefulWidget {
  final VoidCallback onTap;

  const _NewShipmentButton({required this.onTap});

  @override
  State<_NewShipmentButton> createState() => _NewShipmentButtonState();
}

class _NewShipmentButtonState extends State<_NewShipmentButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.teal,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.teal.withAlpha(60),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                L10n.of(context)!.newBtn,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shipment Card ────────────────────────────────────────────────────────────

class _ShipmentCard extends StatelessWidget {
  final Shipment shipment;
  final VoidCallback onTap;

  const _ShipmentCard({required this.shipment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = shipment;

    final l10n = L10n.of(context);
    final (Color statusBg, Color statusFg, Color statusDot, String statusLabel) =
        switch (s.status) {
      ShipmentStatus.pending   => (AppTheme.amberLight, const Color(0xFF92400E), AppTheme.amber, (l10n?.pending ?? 'چاوەڕێ').toUpperCase()),
      ShipmentStatus.inTransit => (AppTheme.blueLight,  const Color(0xFF1D4ED8), AppTheme.blue,  (l10n?.inTransit ?? 'لە ڕێگادایە').toUpperCase()),
      ShipmentStatus.delivered => (AppTheme.tealLight,  const Color(0xFF065F46), AppTheme.teal,  (l10n?.delivered ?? 'گەیشتووە').toUpperCase()),
      ShipmentStatus.reported  => (AppTheme.redLight,   const Color(0xFF991B1B), AppTheme.red,   (l10n?.reported ?? 'ڕاپۆرت کراوە').toUpperCase()),
    };

    final String transportIcon = switch (s.status) {
      ShipmentStatus.pending   => '\u{231B}', // Hourglass ⌛
      ShipmentStatus.inTransit => '\u{1F69B}', // Truck 🚚
      ShipmentStatus.delivered => '\u{2705}', // Check ✅
      ShipmentStatus.reported  => '\u{26A0}', // Warning ⚠️
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──
            Row(
              children: [
                // Transport icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(transportIcon, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${s.origin} \u{2192} ${s.destination}', // Arrow →
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '#${s.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusDot,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusFg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Divider ──
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Bottom row ──
            Row(
              children: [
                _infoChip(
                  icon: Icons.scale_outlined,
                  label: s.weightKg != null ? L10n.of(context)!.kgUnit(s.weightKg!.toStringAsFixed(1)) : s.size ?? L10n.of(context)!.noData,
                ),
                const SizedBox(width: 10),
                _infoChip(
                  icon: Icons.schedule_rounded,
                  label: '${s.estimatedDeliveryDays} ${L10n.of(context)?.days ?? 'ڕۆژ'}',
                ),
                const Spacer(),
                Text(
                  '\$${s.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.muted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
