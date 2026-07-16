final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

abstract final class ContactLeadValidators {
  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa tu nombre';
    if (text.length < 2) return 'El nombre debe tener al menos 2 caracteres';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa tu email';
    if (!_emailPattern.hasMatch(text)) return 'Ingresa un email válido';
    return null;
  }

  static String? phone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Ingresa tu teléfono';
    if (digits.length < 9) return 'El teléfono debe tener al menos 9 dígitos';
    if (digits.length > 15) return 'Teléfono demasiado largo';
    return null;
  }

  static String? message(String? value, {required bool required}) {
    final text = value?.trim() ?? '';
    if (!required) {
      if (text.length > 1000) return 'Máximo 1000 caracteres';
      return null;
    }
    if (text.isEmpty) return 'Escribe un mensaje';
    if (text.length < 10) return 'El mensaje debe tener al menos 10 caracteres';
    if (text.length > 1000) return 'Máximo 1000 caracteres';
    return null;
  }
}
