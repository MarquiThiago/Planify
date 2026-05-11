import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../design_system.dart';

/// Widget para exibir ícones SVG com estyling padrão do Planify
class PlanifySvgIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;

  const PlanifySvgIcon(
    this.assetPath, {
    super.key,
    this.size = 24.0,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width ?? size,
      height: height ?? size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: fit,
      alignment: alignment,
    );
  }
}

/// Widget para exibir SVG em um container com background
class PlanifySvgIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? containerSize;

  const PlanifySvgIconButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.size = 24.0,
    this.iconColor,
    this.backgroundColor,
    this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(
          child: PlanifySvgIcon(
            assetPath,
            size: size,
            color: iconColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Widget para SVG grande (ex: em cards de categoria)
class PlanifySvgIconLarge extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;

  const PlanifySvgIconLarge({
    super.key,
    required this.assetPath,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: padding,
      child: PlanifySvgIcon(
        assetPath,
        size: size,
        color: iconColor ?? AppColors.primary,
      ),
    );
  }
}
