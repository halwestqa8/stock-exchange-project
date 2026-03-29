import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'staff_sidebar.dart';

class StaffShell extends StatelessWidget {
  final String activeRoute;
  final String title;
  final List<Widget>? actions;
  final Widget child;

  const StaffShell({
    super.key,
    required this.activeRoute,
    required this.title,
    this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: isCompact ? AppBar(title: Text(title), actions: actions) : null,
      drawer: isCompact
          ? Drawer(
              backgroundColor: AppTheme.ink,
              child: SafeArea(
                child: StaffSidebar(
                  activeRoute: activeRoute,
                  width: double.infinity,
                  showUserCard: true,
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isCompact)
            StaffSidebar(activeRoute: activeRoute, showUserCard: true),
          Expanded(child: child),
        ],
      ),
    );
  }
}
