import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/device_provider.dart';
import '../../../widgets/device_card.dart';
import '../device_detail/device_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDevices();
    });
  }

  void _loadDevices() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<DeviceProvider>().loadDevices(authProvider.user!.uid);
    } else {
      context.read<DeviceProvider>().loadDevices('mock-user');
    }
  }

  Future<void> _logout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.dashboard,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDevices,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: AppStrings.logout,
          ),
        ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, _) {
          if (deviceProvider.state == DeviceState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
              ),
            );
          }

          if (deviceProvider.devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.devices_other,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text(
                    'No devices found',
                    style: GoogleFonts.inter(
                      fontSize: AppDimensions.fontTitle,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'Add your first IoT device to get started',
                    style: GoogleFonts.inter(
                      fontSize: AppDimensions.fontBody,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authProvider = context.read<AuthProvider>();
              await deviceProvider.refreshDevices(
                authProvider.user?.uid ?? 'mock-user',
              );
            },
            color: AppColors.accentCyan,
            backgroundColor: AppColors.surface,
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.myDevices,
                      style: GoogleFonts.inter(
                        fontSize: AppDimensions.fontTitle,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                        vertical: AppDimensions.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: Text(
                        '${deviceProvider.devices.length}',
                        style: GoogleFonts.inter(
                          fontSize: AppDimensions.fontBody,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ...deviceProvider.devices.map((device) => DeviceCard(
                  device: device,
                  onTap: () {
                    deviceProvider.selectDevice(device);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DeviceDetailScreen(),
                      ),
                    );
                  },
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}