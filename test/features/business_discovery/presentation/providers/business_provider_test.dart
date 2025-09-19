import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:business_card_app/features/business_discovery/data/repositories/business_repository.dart';
import 'package:business_card_app/features/business_discovery/presentation/providers/business_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeBusinessRepository implements BusinessRepository {
  Future<List<Business>> Function()? onGetBusinesses;

  @override
  Future<List<Business>> getBusinesses() async {
    if (onGetBusinesses != null) return onGetBusinesses!();
    throw UnimplementedError('onGetBusinesses not set');
  }
}

void main() {
  group('BusinessProvider', () {
    late BusinessProvider provider;
    late FakeBusinessRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeBusinessRepository();
      provider = BusinessProvider(fakeRepository);
    });

    final tBusiness1 = const Business(
      name: 'Alice',
      location: 'Wonderland',
      contactNumber: '1',
    );
    final tBusiness2 = const Business(
      name: 'Bob',
      location: 'Builderland',
      contactNumber: '2',
    );
    final tBusinessList = [tBusiness1, tBusiness2];

    test('initial state is correct', () {
      expect(provider.state, AppState.initial);
      expect(provider.businesses, isEmpty);
      expect(provider.filteredBusinesses, isEmpty);
    });

    group('fetchBusinesses', () {
      test('should update state to loading, then success with data', () async {
        // Arrange
        fakeRepository.onGetBusinesses = () async => tBusinessList;

        // Act
        final future = provider.fetchBusinesses();
        expect(provider.state, AppState.loading);
        await future;

        // Assert
        expect(provider.state, AppState.success);
        expect(provider.businesses, tBusinessList);
        expect(provider.filteredBusinesses, tBusinessList);
      });

      test('should update state to loading, then error', () async {
        // Arrange
        final errorMessage = 'Error';
        fakeRepository.onGetBusinesses = () async =>
            throw Exception(errorMessage);

        // Act
        final future = provider.fetchBusinesses();
        expect(provider.state, AppState.loading);
        await future;

        // Assert
        expect(provider.state, AppState.error);
        expect(provider.errorMessage, contains(errorMessage));
        expect(provider.businesses, isEmpty);
      });
    });
  });
}
