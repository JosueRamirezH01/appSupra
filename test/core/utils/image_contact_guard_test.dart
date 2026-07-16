import 'package:flutter_test/flutter_test.dart';
import 'package:prueba/core/utils/image_contact_guard.dart';

void main() {
  group('ImageContactGuard.containsContactInText', () {
    test('detects plain peru mobile', () {
      expect(ImageContactGuard.containsContactInText('987654321'), isTrue);
    });

    test('detects formatted peru mobile', () {
      expect(
        ImageContactGuard.containsContactInText('+51 987 654 321'),
        isTrue,
      );
    });

    test('detects keyword with digits', () {
      expect(
        ImageContactGuard.containsContactInText('Cel: 912345678'),
        isTrue,
      );
      expect(
        ImageContactGuard.containsContactInText('WhatsApp: 999888777'),
        isTrue,
      );
    });

    test('allows text without contact patterns', () {
      expect(
        ImageContactGuard.containsContactInText('Obra de construcción terminada'),
        isFalse,
      );
      expect(ImageContactGuard.containsContactInText('S/ 89.90'), isFalse);
    });

    test('allows empty text', () {
      expect(ImageContactGuard.containsContactInText(''), isFalse);
      expect(ImageContactGuard.containsContactInText('   '), isFalse);
    });
  });
}
