import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';
import '../../core/theme.dart';
import '../shipments/assigned_shipments_screen.dart';
import '../shipments/shipment_history_screen.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';

final driverBottomNavProvider = StateProvider<int>((ref) => 0);

class DriverMainShell extends ConsumerWidget {
  const DriverMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(driverBottomNavProvider);
    final l10n = L10n.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: idx,
        children: const [
          AssignedShipmentsScreen(),
          ShipmentHistoryScreen(),
          DriverNotificationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.card,
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) => ref.read(driverBottomNavProvider.notifier).state = i,
          backgroundColor: AppTheme.card,
          selectedItemColor: AppTheme.orange,
          unselectedItemColor: AppTheme.muted,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Text('🚛', style: TextStyle(fontSize: 20)),
              activeIcon: const Text('🚛', style: TextStyle(fontSize: 22)),
              label: l10n.assigned,
            ),
            BottomNavigationBarItem(
              icon: const Text('📋', style: TextStyle(fontSize: 20)),
              activeIcon: const Text('📋', style: TextStyle(fontSize: 22)),
              label: l10n.history,
            ),
            BottomNavigationBarItem(
              icon: const Text('🔔', style: TextStyle(fontSize: 20)),
              activeIcon: const Text('🔔', style: TextStyle(fontSize: 22)),
              label: l10n.alerts,
            ),
            BottomNavigationBarItem(
              icon: const Text('⚙️', style: TextStyle(fontSize: 20)),
              activeIcon: const Text('⚙️', style: TextStyle(fontSize: 22)),
              label: l10n.account,
            ),
          ],
        ),
      ),
    );
  }
}
