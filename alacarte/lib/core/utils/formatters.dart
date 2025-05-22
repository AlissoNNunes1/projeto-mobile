import 'package:intl/intl.dart';

/// Classe utilitária para formatação de texto.
class Formatters {
  // Impedir a instanciação
  Formatters._();

  /// Formata um valor para moeda (R$)
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Formata um número com o símbolo de porcentagem
  static String formatPercentage(double value) {
    final formatter = NumberFormat.percentPattern('pt_BR');
    return formatter.format(value / 100);
  }

  /// Formata um tempo em minutos para horas e minutos
  static String formatMinutesToHoursAndMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return remainingMinutes > 0 
          ? '$hours h $remainingMinutes min' 
          : '$hours h';
    } else {
      return '$minutes min';
    }
  }

  /// Formata um número de calorias
  static String formatCalories(int calories) {
    return '$calories kcal';
  }

  /// Formata um valor nutricional em gramas
  static String formatNutrient(double value) {
    final formatter = NumberFormat.decimalPattern('pt_BR');
    return '${formatter.format(value)}g';
  }

  /// Formata uma data para exibição
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formata uma data e hora para exibição
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formata o nome de um ingrediente com quantidade e unidade
  static String formatIngredientWithMeasure(String name, double quantity, String unit) {
    final formattedQuantity = quantity % 1 == 0
        ? quantity.toInt().toString()
        : quantity.toString();
    
    return '$formattedQuantity $unit de $name';
  }

  /// Trunca um texto longo adicionando "..." no final
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
