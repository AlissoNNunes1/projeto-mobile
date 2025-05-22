import 'package:flutter/material.dart';

/// [SecondaryButton] é um botão personalizado para ações secundárias na aplicação.
/// Tem uma aparência menos proeminente que o botão primário.
class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final double height;
  final double? width;
  final bool isLoading;
  final bool outlined;
  final EdgeInsetsGeometry? padding;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.height = 56.0,
    this.width,
    this.isLoading = false,
    this.outlined = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Usar botão delineado ou texto
    final buttonStyle = outlined
        ? OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          )
        : TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          );

    // Widget a ser exibido dentro do botão
    final buttonChild = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 2.5,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          );

    return SizedBox(
      height: height,
      width: width,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            )
          : TextButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            ),
    );
  }
}
