import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';
import '../../core/dashboard_back_button.dart';

class VehicleManagementScreen extends ConsumerWidget {
  const VehicleManagementScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const DashboardBackButton(),
        title: Text(L10n.of(context)!.vehicleTypes),
      ),
      body: Center(child: Text(L10n.of(context)!.vehicleCrudPlaceholder)),
    );
  }
}
