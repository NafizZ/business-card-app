
import 'package:business_card_app/core/di/service_locator.dart';
import 'package:business_card_app/features/business_discovery/data/repositories/business_repository.dart';
import 'package:business_card_app/features/business_discovery/presentation/providers/business_provider.dart';
import 'package:business_card_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

class MockBusinessRepository extends Mock implements BusinessRepository {}

void main() {
  late MockBusinessRepository mockBusinessRepository;

  setUp(() {
    mockBusinessRepository = MockBusinessRepository();
    // Clear and re-register dependencies for each test
    if (GetIt.instance.isRegistered<BusinessRepository>()) {
      GetIt.instance.unregister<BusinessRepository>();
    }
    if (GetIt.instance.isRegistered<BusinessProvider>()) {
      GetIt.instance.unregister<BusinessProvider>();
    }
    sl.registerLazySingleton<BusinessRepository>(() => mockBusinessRepository);
    sl.registerFactory<BusinessProvider>(
        () => BusinessProvider(sl<BusinessRepository>()));
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('App shows Business Finder title', (WidgetTester tester) async {
    // Arrange
    when(mockBusinessRepository.getBusinesses()).thenAnswer((_) async => []);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Assert
    expect(find.text('Business Finder'), findsOneWidget);
  });
}
