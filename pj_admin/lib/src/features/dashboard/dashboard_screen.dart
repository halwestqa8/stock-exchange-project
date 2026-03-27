import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pj_domain/pj_domain.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import 'shipment_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:pj_l10n/pj_l10n.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  bool _hasShownKeyChangeDialog = false;

  // ── Entrance controller ───────────────────────────────────────────────────
  late final AnimationController _entranceCtrl;

  // ── Sidebar items stagger ─────────────────────────────────────────────────
  late final Animation<Offset> _sidebarSlide;
  late final Animation<double> _sidebarOpacity;

  // ── Header row ────────────────────────────────────────────────────────────
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerOpacity;

  // ── Stats row ─────────────────────────────────────────────────────────────
  late final List<Animation<Offset>> _statSlides;
  late final List<Animation<double>> _statOpacities;

  // ── Table ─────────────────────────────────────────────────────────────────
  late final Animation<double> _tableOpacity;
  late final Animation<Offset> _tableSlide;

  // ── Refresh button spin ───────────────────────────────────────────────────
  late final AnimationController _refreshCtrl;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _refreshCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // ── Sidebar slides from left ──
    _sidebarSlide = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.00, 0.50, curve: Curves.easeOutCubic),
    ));
    _sidebarOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOut),
      ),
    );

    // ── Header slides down from top ──
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.10, 0.55, curve: Curves.easeOutCubic),
    ));
    _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.10, 0.42, curve: Curves.easeOut),
      ),
    );

    // ── 5 stat cards — staggered slide up ──
    _statSlides = List.generate(5, (i) {
      final start = 0.28 + i * 0.07;
      final end = (start + 0.30).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.70),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _entranceCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });
    _statOpacities = List.generate(5, (i) {
      final start = 0.28 + i * 0.07;
      final end = (start + 0.22).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // ── Table fades in ──
    _tableSlide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic),
    ));
    _tableOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.60, 0.90, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _refreshCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(authProvider);
    final shipmentsAsync = ref.watch(shipmentListProvider);

    if (user != null &&
        DateTime.now().difference(ref.watch(lastKeyChangeProvider)) >
            const Duration(days: 90) &&
        !_hasShownKeyChangeDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(L10n.of(context)!.changeAdminKey),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(L10n.of(context)!.keyExpiredMessage),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    const uuid = Uuid();
                    final newKey = uuid.v4();
                    await ref
                        .read(lastKeyChangeProvider.notifier)
                        .markChangedNow();
                    // ignore: avoid_print
                    print('New key saved: $newKey');
                    if (!context.mounted) return;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(L10n.of(context)!.generateNewKey),
                ),
              ],
            ),
          ),
        ).then((_) => setState(() => _hasShownKeyChangeDialog = true));
      });
    }

    return Scaffold(
      body: Row(
        children: [
          // ── Animated Sidebar ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _entranceCtrl,
            builder: (_, child) => SlideTransition(
              position: _sidebarSlide,
              child: FadeTransition(opacity: _sidebarOpacity, child: child),
            ),
            child: _buildSidebar(context, ref, user, '/'),
          ),

          // ── Main Content ────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ──
                  AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, child) => SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                          opacity: _headerOpacity, child: child),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(L10n.of(context)!.overview, style: tt.headlineLarge),
                            const SizedBox(height: 2),
                            Text(
                              L10n.of(context)!.systemOverview,
                              style: tt.bodyMedium
                                  ?.copyWith(color: AppTheme.muted),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Language toggle
                        Consumer(
                          builder: (context, ref, _) {
                            final locale = ref.watch(localeProvider);
                            return TextButton.icon(
                              onPressed: () => ref.read(localeProvider.notifier).toggle(),
                              icon: const Text('\u{1F310}', style: TextStyle(fontSize: 16)), // Globe 🌐
                              label: Text(
                                locale.languageCode == 'ku'
                                    ? L10n.of(context)!.english
                                    : L10n.of(context)!.kurdish,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        // Animated refresh button
                        _RefreshButton(
                          refreshCtrl: _refreshCtrl,
                          onPressed: () {
                            _refreshCtrl.forward(from: 0);
                            final _ = ref.refresh(shipmentListProvider);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Stat cards ──
                  shipmentsAsync.when(
                    data: (shipments) {
                      final p = shipments
                          .where(
                              (s) => s.status == ShipmentStatus.pending)
                          .length;
                      final t = shipments
                          .where(
                              (s) => s.status == ShipmentStatus.inTransit)
                          .length;
                      final d = shipments
                          .where(
                              (s) => s.status == ShipmentStatus.delivered)
                          .length;
                      final r = shipments
                          .where(
                              (s) => s.status == ShipmentStatus.reported)
                          .length;

                      final stats = [
                        _StatData('\u{1F4E6}', shipments.length, L10n.of(context)!.total, // Package 📦
                            AppTheme.roseLight),
                        _StatData('\u{231B}', p, L10n.of(context)!.pendingCount, AppTheme.amberLight), // Hourglass ⌛
                        _StatData('\u{1F69B}', t, L10n.of(context)!.transit, AppTheme.blueLight), // Truck 🚚
                        _StatData(
                            '\u{2705}', d, L10n.of(context)!.deliveredCount, AppTheme.tealLight), // Check ✅
                        _StatData('\u{26A0}', r, L10n.of(context)!.reportedCount, AppTheme.redLight), // Warning ⚠️
                      ];

                      return Row(
                        children: stats.asMap().entries.map((e) {
                          final i = e.key;
                          final s = e.value;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: i < stats.length - 1 ? 12 : 0),
                              child: AnimatedBuilder(
                                animation: _entranceCtrl,
                                builder: (_, child) => SlideTransition(
                                  position: _statSlides[i],
                                  child: FadeTransition(
                                    opacity: _statOpacities[i],
                                    child: child,
                                  ),
                                ),
                                child: _AnimatedStatCard(
                                  emoji: s.emoji,
                                  value: s.value,
                                  label: s.label,
                                  bg: s.bg,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const SizedBox(height: 78),
                    error: (_, _) => const SizedBox(height: 78),
                  ),
                  const SizedBox(height: 22),

                  // ── Data table ──
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _entranceCtrl,
                      builder: (_, child) => SlideTransition(
                        position: _tableSlide,
                        child: FadeTransition(
                            opacity: _tableOpacity, child: child),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(6),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: shipmentsAsync.when(
                          data: (shipments) => ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: DataTable2(
                              columnSpacing: 12,
                              horizontalMargin: 20,
                              minWidth: 600,
                              headingRowHeight: 48,
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
                                    label: Text(L10n.of(context)!.id), size: ColumnSize.S),
                                DataColumn2(label: Text(L10n.of(context)!.route)),
                                DataColumn2(
                                    label: Text(L10n.of(context)!.weightLabel),
                                    size: ColumnSize.S),
                                DataColumn2(
                                    label: Text(L10n.of(context)!.priceLabel),
                                    size: ColumnSize.S),
                                DataColumn2(
                                    label: Text(L10n.of(context)!.statusLabel),
                                    size: ColumnSize.S),
                              ],
                              rows: shipments
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final s = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                      '#${s.id.substring(0, 8)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    )),
                                    DataCell(Text(
                                        '${s.origin} \u{2192} ${s.destination}')), // Arrow →
                                    DataCell(Text(
                                        s.weightKg != null ? L10n.of(context)!.kgUnit(s.weightKg!.toStringAsFixed(0)) : '-')),
                                    DataCell(Text(
                                        '\$${s.totalPrice.toStringAsFixed(2)}')),
                                    DataCell(
                                        StatusBadge(
                                          status: s.status,
                                          label: switch (s.status) {
                                            ShipmentStatus.pending => L10n.of(context)!.pending,
                                            ShipmentStatus.inTransit => L10n.of(context)!.inTransit,
                                            ShipmentStatus.delivered => L10n.of(context)!.delivered,
                                            ShipmentStatus.reported => L10n.of(context)!.reported,
                                          },
                                        )),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          loading: () => const Center(
                              child: CircularProgressIndicator()),
                          error: (e, _) =>
                              Center(child: Text('${L10n.of(context)!.error}: $e')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sidebar builder ──────────────────────────────────────────────────────
  static Widget _buildSidebar(
      BuildContext context, WidgetRef ref, user, String activePath) {
    return Container(
      width: 240,
      color: AppTheme.ink,
      child: Column(
        children: [
          const SizedBox(height: 28),

          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.rose, Color(0xFFFB7185)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.rose.withAlpha(80),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                      child: Text('\u{1F6E1}', style: TextStyle(fontSize: 18))), // Shield 🛡️
                ),
                const SizedBox(width: 10),
                Text(
                  L10n.of(context)!.ltmsAdmin,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Nav items
          _AnimatedSidebarItem(
            emoji: '\u{1F3E0}', // House 🏠
            label: L10n.of(context)!.overview,
            index: 0,
            active: activePath == '/',
            onTap: () => context.go('/'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{1F465}', // Users 👥
            label: L10n.of(context)!.usersLabel,
            index: 1,
            active: activePath == '/users',
            onTap: () => context.go('/users'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{1F4E6}', // Package 📦
            label: L10n.of(context)!.catalogLabel,
            index: 2,
            active: activePath == '/catalog',
            onTap: () => context.go('/catalog'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{1F5C2}', // Folder 🗂️
            label: L10n.of(context)!.categories,
            index: 3,
            active: activePath == '/categories',
            onTap: () => context.go('/categories'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{1F69B}', // Truck 🚚
            label: L10n.of(context)!.vehiclesLabel,
            index: 4,
            active: activePath == '/vehicles',
            onTap: () => context.go('/vehicles'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{2753}', // Question ❓
            label: L10n.of(context)!.faqLabel,
            index: 5,
            active: activePath == '/faq',
            onTap: () => context.go('/faq'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{1F4B0}', // Money 💰
            label: L10n.of(context)!.pricingLabel,
            index: 6,
            active: activePath == '/pricing',
            onTap: () => context.go('/pricing'),
          ),
          _AnimatedSidebarItem(
            emoji: '\u{1F4CA}', // Chart 📊
            label: L10n.of(context)!.reportsLabel,
            index: 7,
            active: activePath == '/reports',
            onTap: () => context.go('/reports'),
          ),

          const Spacer(),

          // User card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(13),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.white.withAlpha(18), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.rose, Color(0xFFFB7185)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        (user?.name ?? 'A')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? L10n.of(context)!.adminRole,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          L10n.of(context)!.adminRole,
                          style: TextStyle(
                            color: Colors.white.withAlpha(100),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _LogoutButton(
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat data model ────────────────────────────────────────────────────────────

class _StatData {
  final String emoji;
  final int value;
  final String label;
  final Color bg;

  const _StatData(this.emoji, this.value, this.label, this.bg);
}

// ── Animated stat card with count-up ──────────────────────────────────────────

class _AnimatedStatCard extends StatefulWidget {
  final String emoji;
  final int value;
  final String label;
  final Color bg;

  const _AnimatedStatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.bg,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<int> _count;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _count = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.04)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.04, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_ctrl);
    _ctrl.forward();
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
      builder: (_, _) => Transform.scale(
        scale: _scale.value,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border.withAlpha(100)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_count.value}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.ink,
                    ),
                  ),
                  Text(
                    widget.label,
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
        ),
      ),
    );
  }
}

// ── Animated sidebar item ──────────────────────────────────────────────────────

class _AnimatedSidebarItem extends StatefulWidget {
  final String emoji;
  final String label;
  final int index;
  final bool active;
  final VoidCallback onTap;

  const _AnimatedSidebarItem({
    required this.emoji,
    required this.label,
    required this.index,
    required this.active,
    required this.onTap,
  });

  @override
  State<_AnimatedSidebarItem> createState() => _AnimatedSidebarItemState();
}

class _AnimatedSidebarItemState extends State<_AnimatedSidebarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverCtrl;

  late final Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!widget.active) {
          setState(() => _hovered = true);
          _hoverCtrl.forward();
        }
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _hoverCtrl.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => _hoverCtrl.forward(),
        onTapUp: (_) {
          _hoverCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _hoverCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _hoverCtrl,
          builder: (_, child) => Transform.scale(
            scale: _scale.value,
            child: child,
          ),
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.active
                  ? Colors.white.withAlpha(20)
                  : (_hovered ? Colors.white.withAlpha(10) : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
              border: widget.active
                  ? Border.all(
                      color: Colors.white.withAlpha(15), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Text(widget.emoji,
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.active
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.active
                        ? Colors.white
                        : Colors.white.withAlpha(128),
                  ),
                ),
                if (widget.active) ...[
                  const Spacer(),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.rose,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Spinning refresh button ────────────────────────────────────────────────────

class _RefreshButton extends StatelessWidget {
  final AnimationController refreshCtrl;
  final VoidCallback onPressed;

  const _RefreshButton({
    required this.refreshCtrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: AnimatedBuilder(
        animation: refreshCtrl,
        builder: (_, child) => Transform.rotate(
          angle: refreshCtrl.value * 2 * 3.14159,
          child: child,
        ),
        child: const Icon(Icons.refresh_rounded, size: 18),
      ),
      label: Text(L10n.of(context)!.refresh),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.rose,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        shadowColor: AppTheme.rose.withAlpha(80),
      ),
    );
  }
}

// ── Logout button with hover ───────────────────────────────────────────────────

class _LogoutButton extends StatefulWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) =>
              Opacity(opacity: _opacity.value, child: child),
          child: Icon(
            Icons.logout_rounded,
            size: 18,
            color: Colors.white.withAlpha(180),
          ),
        ),
      ),
    );
  }
}
