import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:prueba/core/utils/location_service.dart';

void main() {
  group('LocationService.formatStreetAddress', () {
    test('joins street and number with district', () {
      const place = Placemark(
        thoroughfare: 'Av. Las Palmeras',
        subThoroughfare: '123',
        locality: 'Los Olivos',
        administrativeArea: 'Lima',
      );

      expect(
        LocationService.formatStreetAddress(place),
        'Av. Las Palmeras 123, Los Olivos',
      );
    });

    test('does not duplicate number already in the street', () {
      const place = Placemark(
        thoroughfare: 'Av. Las Palmeras 123',
        subThoroughfare: '123',
        locality: 'Los Olivos',
        administrativeArea: 'Lima',
      );

      expect(
        LocationService.formatStreetAddress(place),
        'Av. Las Palmeras 123, Los Olivos',
      );
    });

    test('falls back to district and city when there is no street', () {
      const place = Placemark(
        locality: 'Los Olivos',
        administrativeArea: 'Lima',
      );

      expect(
        LocationService.formatStreetAddress(place),
        'Los Olivos, Lima',
      );
      expect(
        LocationService.formatDistrictCity(place),
        'Los Olivos, Lima',
      );
    });

    test('ignores plus codes and unnamed roads', () {
      const plusCode = Placemark(
        thoroughfare: '8FQC+5X',
        locality: 'Comas',
        administrativeArea: 'Lima',
      );
      const unnamed = Placemark(
        street: 'Unnamed Road',
        locality: 'Puente Piedra',
        administrativeArea: 'Lima',
      );

      expect(LocationService.formatStreetAddress(plusCode), 'Comas, Lima');
      expect(
        LocationService.formatStreetAddress(unnamed),
        'Puente Piedra, Lima',
      );
    });
  });
}
