import 'package:flutter/material.dart';

/// Reusable widget for interactive border animation
/// Wraps any child with AnimatedContainer + InkWell
/// Shows border on hover (PC) or press (mobile)
class AnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double? borderWidth;
  final Duration animationDuration;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const AnimatedBorderContainer({
    super.key,
    required this.child,
    this.onTap,
    this.borderColor,
    this.borderWidth,
    this.animationDuration = const Duration(milliseconds: 200),
    this.borderRadius,
    this.backgroundColor,
    this.padding,
  });

  @override
  State<AnimatedBorderContainer> createState() => _AnimatedBorderContainerState();
}

class _AnimatedBorderContainerState extends State<AnimatedBorderContainer> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.borderColor ?? const Color(0xff3ecf8e);
    final effectiveBorderWidth = widget.borderWidth ?? 2.0;
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    return InkWell(
      onTap: widget.onTap,
      onHover: (isHovered) {
        setState(() {
          _isHovered = isHovered;
        });
      },
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: effectiveBorderRadius,
          border: Border.all(
            color: (_isHovered || _isPressed) ? effectiveBorderColor : Colors.transparent,
            width: effectiveBorderWidth,
          ),
        ),
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
