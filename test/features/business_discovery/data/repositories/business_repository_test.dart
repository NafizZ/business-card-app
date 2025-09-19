import 'package:business_card_app/core/api/api_service.dart';
import 'package:business_card_app/core/persistence/persistence_service.dart';
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:business_card_app/features/business_discovery/data/repositories/business_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple fake implementations to avoid Mockito null-safety complexity.
class FakeApiService implements ApiService {
  Future<List<Business>> Function()? onFetch;

  @override
  Future<List<Business>> fetchBusinesses() async {
    if (onFetch != null) return onFetch!();
    throw UnimplementedError('onFetch not set');
  }
}

class FakePersistenceService implements PersistenceService {
  Future<void> Function(List<Business>)? onSave;
  Future<List<Business>> Function()? onLoad;

  bool saveCalled = false;
  List<Business>? savedData;
  bool loadCalled = false;

  @override
  Future<void> saveBusinessData(List<Business> businesses) async {
    saveCalled = true;
    savedData = businesses;
    if (onSave != null) return onSave!(businesses);
  }

  @override
  Future<List<Business>> loadBusinessData() async {
    loadCalled = true;
    if (onLoad != null) return onLoad!();
    return [];
  }
}

void main() {
  group('BusinessRepository', () {
    late BusinessRepository repository;
    late FakeApiService fakeApiService;
    late FakePersistenceService fakePersistenceService;

    setUp(() {
      fakeApiService = FakeApiService();
      fakePersistenceService = FakePersistenceService();
      repository = BusinessRepository(fakeApiService, fakePersistenceService);
    });

    final tBusiness = const Business(
      name: 'Test Business',
      location: 'Test Location',
      contactNumber: '1234567890',
    );
    final tBusinessList = [tBusiness];

    group('getBusinesses', () {
      test(
        'should fetch from API, save to persistence, and return list when API call is successful',
        () async {
          // arrange
          // arrange
          fakeApiService.onFetch = () async => tBusinessList;

          // act
          final result = await repository.getBusinesses();

          // assert
          expect(fakePersistenceService.saveCalled, true);
          expect(fakePersistenceService.savedData, tBusinessList);
          expect(result, tBusinessList);
        },
      );

      test(
        'should return list from persistence when API call fails but persistence has data',
        () async {
          // arrange
          // arrange: API throws, persistence returns data
          fakeApiService.onFetch = () async => throw Exception('API Error');
          fakePersistenceService.onLoad = () async => tBusinessList;

          // act
          final result = await repository.getBusinesses();

          // assert
          expect(result, tBusinessList);
          expect(fakePersistenceService.loadCalled, true);
        },
      );

      test(
        'should rethrow exception when API call fails and persistence is empty',
        () async {
          // arrange
          // arrange
          fakeApiService.onFetch = () async => throw Exception('API Error');
          fakePersistenceService.onLoad = () async => [];

          // act & assert
          await expectLater(
            repository.getBusinesses(),
            throwsA(isA<Exception>()),
          );
          expect(fakePersistenceService.loadCalled, true);
        },
      );
    });
  });
}
