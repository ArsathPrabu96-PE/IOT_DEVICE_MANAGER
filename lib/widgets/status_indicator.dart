import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StatusIndicator extends StatefulWidget {
  final bool isOnline;
  final bool isOn;
  final double size;

  const StatusIndicator({
    super.key,
    required this.isOnline,
    required this.isOn,
    this.size = 8,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isOnline && widget.isOn) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOnline && widget.isOn) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    if (!widget.isOnline) {
      color = AppColors.textSecondary;
    } else if (widget.isOn) {
      color = AppColors.accentGreen;
    } else {
      color = AppColors.accentRed;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isOnline && widget.isOn
                ? color.withValues(alpha: _animation.value)
                : color,
            boxShadow: widget.isOnline && widget.isOn
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: widget.size,
                      spreadRadius: widget.size / 4,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}