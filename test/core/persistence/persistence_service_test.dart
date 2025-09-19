
import 'dart:convert';

import 'package:business_card_app/core/persistence/persistence_service.dart';
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PersistenceService', () {
    late PersistenceService persistenceService;
    late SharedPreferences sharedPreferences;

    final tBusiness = const Business(
      name: 'Test Business',
      location: 'Test Location',
      contactNumber: '1234567890',
    );
    final tBusinessList = [tBusiness];
    final tBusinessJsonList = [
      json.encode(tBusiness.toJson()),
    ];

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'businesses_data': tBusinessJsonList,
      });
      sharedPreferences = await SharedPreferences.getInstance();
      persistenceService = PersistenceService();
    });

    group('saveBusinessData', () {
      test('should call SharedPreferences to save data', () async {
        // arrange
        final businessListToSave = [tBusiness, tBusiness];
        final expectedJsonList = businessListToSave
            .map((b) => json.encode(b.toJson()))
            .toList();

        // act
        await persistenceService.saveBusinessData(businessListToSave);

        // assert
        final actualJsonList = sharedPreferences.getStringList('businesses_data');
        expect(actualJsonList, expectedJsonList);
      });
    });

    group('loadBusinessData', () {
      test('should return a list of businesses from SharedPreferences', () async {
        // act
        final result = await persistenceService.loadBusinessData();

        // assert
        expect(result, tBusinessList);
      });

      test('should return an empty list when there is no data', () async {
        // arrange
        SharedPreferences.setMockInitialValues({});
        persistenceService = PersistenceService();

        // act
        final result = await persistenceService.loadBusinessData();

        // assert
        expect(result, []);
      });
    });
  });
}
