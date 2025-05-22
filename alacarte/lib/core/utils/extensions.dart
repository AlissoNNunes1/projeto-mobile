import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extensões para objetos String
extension StringExtension on String {
  /// Capitaliza a primeira letra de cada palavra
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  /// Formata tempo em minutos para horas e minutos (exemplo: "1h 30min")
  String formatMinutes() {
    final minutes = int.tryParse(this);
    if (minutes == null) return this;

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return remainingMinutes > 0 
          ? '${hours}h ${remainingMinutes}min' 
          : '${hours}h';
    } else {
      return '${remainingMinutes}min';
    }
  }
}

/// Extensões para objetos DateTime
extension DateTimeExtension on DateTime {
  /// Formata a data para o padrão brasileiro (dd/MM/yyyy)
  String formatDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Formata a data e hora para o padrão brasileiro (dd/MM/yyyy HH:mm)
  String formatDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Retorna a diferença em dias em relação à data atual
  int get daysFromNow {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .difference(DateTime(year, month, day))
        .inDays;
  }

  /// Retorna um texto amigável sobre quando a data ocorreu (hoje, ontem, etc.)
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Agora';
        } else {
          return 'Há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
        }
      } else {
        return 'Há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      }
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Há $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Há $months ${months == 1 ? 'mês' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Há $years ${years == 1 ? 'ano' : 'anos'}';
    }
  }
}

/// Extensões para objetos BuildContext
extension BuildContextExtension on BuildContext {
  /// Acessa o tema do aplicativo
  ThemeData get theme => Theme.of(this);

  /// Acessa as cores do tema
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Acessa os estilos de texto do tema
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Retorna o tamanho da tela
  Size get screenSize => MediaQuery.of(this).size;

  /// Verifica se o dispositivo está em modo paisagem
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Acessa o padding seguro da tela
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Exibe uma snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colors.error : colors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Exibe um diálogo de confirmação
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Extensões para objetos List
extension ListExtension<T> on List<T> {
  /// Retorna uma lista com elementos agrupados em sublistas do tamanho especificado
  List<List<T>> chunked(int chunkSize) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < length; i += chunkSize) {
      final end = (i + chunkSize < length) ? i + chunkSize : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }
}
