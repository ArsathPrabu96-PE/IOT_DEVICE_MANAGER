import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/device_model.dart';
import 'status_indicator.dart';
import 'temperature_display.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
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
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusIndicator(
                          isOnline: device.isOnline,
                          isOn: device.isOn,
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Expanded(
                          child: Text(
                            device.name,
                            style: GoogleFonts.inter(
                              fontSize: AppDimensions.fontSubhead,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Text(
                      device.isOn ? 'Temperature' : 'Device is off',
                      style: GoogleFonts.inter(
                        fontSize: AppDimensions.fontCaption,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (device.isOn)
                    TemperatureDisplay(
                      temperature: device.temperature,
                      compact: true,
                    ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingS,
                      vertical: AppDimensions.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: device.isOn
                          ? AppColors.accentGreen.withValues(alpha: 0.15)
                          : AppColors.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: Text(
                      device.isOn ? 'ON' : 'OFF',
                      style: GoogleFonts.inter(
                        fontSize: AppDimensions.fontCaption,
                        fontWeight: FontWeight.w600,
                        color: device.isOn
                            ? AppColors.accentGreen
                            : AppColors.accentRed,
                      ),
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