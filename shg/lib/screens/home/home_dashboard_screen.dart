import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupState = ref.watch(groupProvider);
    final authState = ref.watch(authProvider);

    if (groupState.currentGroup == null) {
      print('No current group selected');
      return Scaffold(
        appBar: AppBar(title: Text(l10n.dashboard)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final dashboardAsync =
        ref.watch(dashboardProvider(groupState.currentGroup!.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(groupState.currentGroup?.name ?? l10n.app_name),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, l10n, authState),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardProvider(groupState.currentGroup!.id));
        },
        child: dashboardAsync.when(
          data: (data) => _buildDashboard(context, l10n, data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(l10n.error),
                const SizedBox(height: 8),
                Text(error.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                        dashboardProvider(groupState.currentGroup!.id));
                  },
                  child: Text(l10n.try_again),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(
      BuildContext context, AppLocalizations l10n, AuthState authState) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryGreen),
            accountName: Text(authState.user?.name ?? 'User'),
            accountEmail: Text(authState.user?.phone ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppTheme.primaryGreen),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(l10n.dashboard),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(l10n.bookkeeping),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.transactionsList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: Text(l10n.loans),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.loansDashboard);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(l10n.products),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.productsList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text(l10n.orders),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.ordersList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text(l10n.reports),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.reportsDashboard);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.languageSelection,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
      BuildContext context, AppLocalizations l10n, Map<String, dynamic> data) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboard,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, // Increased spacing for better look
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildSummaryCard(
                l10n.cash_in_hand,
                '₹${(data['cashInHand'] ?? 0).toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                const Color(0xFF00B4DB), // Vibrant Cyan/Blue
              ),
              _buildSummaryCard(
                l10n.group_savings,
                '₹${(data['groupSavings'] ?? 0).toStringAsFixed(2)}',
                Icons.savings,
                const Color(0xFFF09819), // Vibrant Orange
              ),
              _buildSummaryCard(
                l10n.due_loans,
                '${data['dueLoans'] ?? 0}',
                Icons.warning_rounded,
                const Color(0xFFED213A), // Vibrant Red
              ),
              _buildSummaryCard(
                l10n.todays_tasks,
                '${data['todayTasks'] ?? 0}',
                Icons.assignment_turned_in,
                const Color(0xFF56AB2F), // Vibrant Green
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.quick_actions,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionChip(context, l10n.bookkeeping, Icons.book,
                  AppRoutes.transactionsList),
              _buildActionChip(
                  context, l10n.loans, Icons.money, AppRoutes.loansDashboard),
              _buildActionChip(context, l10n.products, Icons.shopping_bag,
                  AppRoutes.productsList),
              _buildActionChip(context, l10n.orders, Icons.shopping_cart,
                  AppRoutes.ordersList),
              _buildActionChip(context, l10n.reports, Icons.bar_chart,
                  AppRoutes.reportsDashboard),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0, // Elevation is handled by the container shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.8)],
                ),
              ),
            ),
            // Large Background Icon (Decorative)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 80,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 24, color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(
      BuildContext context, String label, IconData icon, String route) {
    return ActionChip(
      avatar: Icon(icon, size: 20, color: AppTheme.primaryGreen),
      label: Text(label),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.5),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
