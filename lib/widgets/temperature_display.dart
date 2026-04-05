import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class TemperatureDisplay extends StatelessWidget {
  final double temperature;
  final bool compact;

  const TemperatureDisplay({
    super.key,
    required this.temperature,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Text(
        '${temperature.toStringAsFixed(1)}°C',
        style: GoogleFonts.inter(
          fontSize: AppDimensions.fontTitle,
          fontWeight: FontWeight.bold,
          color: AppColors.accentCyan,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          temperature.toStringAsFixed(1),
          style: GoogleFonts.inter(
            fontSize: AppDimensions.temperatureDisplaySize,
            fontWeight: FontWeight.bold,
            color: AppColors.accentCyan,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '°C',
            style: GoogleFonts.inter(
              fontSize: AppDimensions.fontTitle,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}