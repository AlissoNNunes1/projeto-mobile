/// Classe utilitária para validação de campos de formulário.
class Validators {
  // Impedir a instanciação
  Validators._();

  /// Valida um endereço de email.
  /// Retorna null se for válido, ou uma mensagem de erro se for inválido.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'Informe um email válido';
    }

    return null;
  }

  /// Valida uma senha.
  /// Retorna null se for válida, ou uma mensagem de erro se for inválida.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  /// Valida se dois valores são iguais (útil para confirmação de senha).
  /// Retorna null se forem iguais, ou uma mensagem de erro se forem diferentes.
  static String? validatePasswordMatch(String? value, String? confirmValue) {
    if (value == null || confirmValue == null) {
      return 'As senhas são obrigatórias';
    }

    if (value != confirmValue) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  /// Valida um nome.
  /// Retorna null se for válido, ou uma mensagem de erro se for inválido.
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  /// Valida se um valor não está vazio.
  /// Retorna null se for válido, ou uma mensagem de erro se for inválido.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }

    return null;
  }

  /// Valida um número de porções.
  /// Retorna null se for válido, ou uma mensagem de erro se for inválido.
  static String? validateServings(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número de porções é obrigatório';
    }

    final servings = int.tryParse(value);
    if (servings == null) {
      return 'Informe um número válido';
    }

    if (servings <= 0) {
      return 'O número de porções deve ser maior que zero';
    }

    return null;
  }

  /// Valida um tempo de preparo em minutos.
  /// Retorna null se for válido, ou uma mensagem de erro se for inválido.
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tempo é obrigatório';
    }

    final time = int.tryParse(value);
    if (time == null) {
      return 'Informe um número válido';
    }

    if (time <= 0) {
      return 'O tempo deve ser maior que zero';
    }

    return null;
  }
}
