import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../providers/device_provider.dart';
import '../../../widgets/temperature_display.dart';
import '../../../widgets/status_indicator.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<DeviceProvider>(
          builder: (context, provider, _) {
            return Text(
              provider.selectedDevice?.name ?? 'Device',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, _) {
          final device = deviceProvider.selectedDevice;

          if (device == null) {
            return const Center(
              child: Text('No device selected'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatusIndicator(
                            isOnline: device.isOnline,
                            isOn: device.isOn,
                            size: 12,
                          ),
                          const SizedBox(width: AppDimensions.paddingS),
                          Text(
                            device.isOnline
                                ? (device.isOn ? AppStrings.online : AppStrings.offline)
                                : AppStrings.offline,
                            style: GoogleFonts.inter(
                              fontSize: AppDimensions.fontBody,
                              fontWeight: FontWeight.w600,
                              color: device.isOnline && device.isOn
                                  ? AppColors.accentGreen
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingXL),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: TemperatureDisplay(
                          key: ValueKey(device.temperature),
                          temperature: device.temperature,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        AppStrings.temperature,
                        style: GoogleFonts.inter(
                          fontSize: AppDimensions.fontBody,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
                _buildInfoRow(
                  AppStrings.status,
                  device.isOn ? AppStrings.deviceOn : AppStrings.deviceOff,
                  device.isOn ? AppColors.accentGreen : AppColors.accentRed,
                ),
                const SizedBox(height: AppDimensions.paddingM),
                _buildInfoRow(
                  AppStrings.lastUpdated,
                  DateFormatter.formatDateTime(device.lastUpdated),
                  AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  AppStrings.toggleDevice,
                  style: GoogleFonts.inter(
                    fontSize: AppDimensions.fontTitle,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                _buildToggleButton(context, deviceProvider, device.isOn),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: AppDimensions.fontBody,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: AppDimensions.fontBody,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    DeviceProvider deviceProvider,
    bool currentStatus,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          deviceProvider.toggleDevice(
            deviceProvider.selectedDevice!.id,
            !currentStatus,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: currentStatus
              ? AppColors.accentRed
              : AppColors.accentGreen,
          foregroundColor: AppColors.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              currentStatus ? Icons.power_off : Icons.power_settings_new,
              size: 24,
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Text(
              currentStatus ? 'Turn OFF' : 'Turn ON',
              style: GoogleFonts.inter(
                fontSize: AppDimensions.fontSubhead,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}