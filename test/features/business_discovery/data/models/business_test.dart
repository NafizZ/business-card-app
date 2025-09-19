
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Business Model', () {
    final tBusiness = const Business(
      name: 'Test Business',
      location: 'Test Location',
      contactNumber: '1234567890',
    );

    final tBusinessJson = {
      'biz_name': 'Test Business',
      'bss_location': 'Test Location',
      'contct_no': '1234567890',
    };

    test('should be a subclass of Equatable', () {
      expect(tBusiness, isA<Business>());
    });

    test('should return a valid model from JSON', () {
      // act
      final result = Business.fromJson(tBusinessJson);
      // assert
      expect(result, tBusiness);
    });

    test('should return a JSON map containing the proper data', () {
      // act
      final result = tBusiness.toJson();
      // assert
      expect(result, tBusinessJson);
    });

    test('should have correct props for equatable', () {
      // assert
      expect(tBusiness.props, ['Test Business', 'Test Location', '1234567890']);
    });
  });
}
