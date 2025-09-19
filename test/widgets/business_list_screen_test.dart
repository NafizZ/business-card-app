import 'package:business_card_app/core/di/service_locator.dart';
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:business_card_app/features/business_discovery/data/repositories/business_repository.dart';
import 'package:business_card_app/features/business_discovery/presentation/providers/business_provider.dart';
import 'package:business_card_app/features/business_discovery/presentation/screens/business_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:business_card_app/features/business_discovery/presentation/widgets/reusable_card.dart';

class FakeBusinessRepository implements BusinessRepository {
  Future<List<Business>> Function()? onGetBusinesses;

  @override
  Future<List<Business>> getBusinesses() async {
    if (onGetBusinesses != null) return onGetBusinesses!();
    return [];
  }
}

void main() {
  late FakeBusinessRepository fakeBusinessRepository;

  setUp(() {
    fakeBusinessRepository = FakeBusinessRepository();
    // Clear and re-register dependencies for each test
    if (GetIt.instance.isRegistered<BusinessRepository>()) {
      GetIt.instance.unregister<BusinessRepository>();
    }
    if (GetIt.instance.isRegistered<BusinessProvider>()) {
      GetIt.instance.unregister<BusinessProvider>();
    }
    sl.registerLazySingleton<BusinessRepository>(() => fakeBusinessRepository);
    sl.registerFactory<BusinessProvider>(
      () => BusinessProvider(sl<BusinessRepository>()),
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('BusinessListScreen', () {
    testWidgets('shows loading indicator initially', (
      WidgetTester tester,
    ) async {
      // make repository delay briefly so loading state is visible
      fakeBusinessRepository.onGetBusinesses = () async =>
          await Future.delayed(const Duration(milliseconds: 50), () => []);

      final provider = BusinessProvider(fakeBusinessRepository);

      await tester.pumpWidget(
        ChangeNotifierProvider<BusinessProvider>.value(
          value: provider,
          child: const MaterialApp(home: BusinessListScreen()),
        ),
      );

      // trigger fetch and show loading
      provider.fetchBusinesses();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('shows list of businesses when data is loaded', (
      WidgetTester tester,
    ) async {
      final tBusinessList = [
        const Business(name: 'Test1', location: 'Loc1', contactNumber: '1'),
        const Business(name: 'Test2', location: 'Loc2', contactNumber: '2'),
      ];
      fakeBusinessRepository.onGetBusinesses = () async => tBusinessList;

      final provider = BusinessProvider(fakeBusinessRepository);

      await tester.pumpWidget(
        ChangeNotifierProvider<BusinessProvider>.value(
          value: provider,
          child: const MaterialApp(home: BusinessListScreen()),
        ),
      );

      // trigger fetch
      provider.fetchBusinesses();
      await tester.pumpAndSettle(); // Wait for data to load and UI to rebuild

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.widgetWithText(ReusableCard, 'Test1'), findsOneWidget);
      expect(find.widgetWithText(ReusableCard, 'Test2'), findsOneWidget);
    });

    testWidgets('shows error message when data loading fails', (
      WidgetTester tester,
    ) async {
      fakeBusinessRepository.onGetBusinesses = () async =>
          throw Exception('Failed to load');

      final provider = BusinessProvider(fakeBusinessRepository);

      await tester.pumpWidget(
        ChangeNotifierProvider<BusinessProvider>.value(
          value: provider,
          child: const MaterialApp(home: BusinessListScreen()),
        ),
      );

      // trigger fetch
      provider.fetchBusinesses();
      await tester.pumpAndSettle(); // Wait for data to load and UI to rebuild

      expect(find.text('An error occurred'), findsOneWidget);
      expect(find.textContaining('Failed to load'), findsOneWidget);
    });

    testWidgets('filters businesses based on search query', (
      WidgetTester tester,
    ) async {
      final tBusinessList = [
        const Business(
          name: 'Apple',
          location: 'Cupertino',
          contactNumber: '1',
        ),
        const Business(name: 'Banana', location: 'Jungle', contactNumber: '2'),
        const Business(name: 'Orange', location: 'Florida', contactNumber: '3'),
      ];
      fakeBusinessRepository.onGetBusinesses = () async => tBusinessList;

      final provider = BusinessProvider(fakeBusinessRepository);

      await tester.pumpWidget(
        ChangeNotifierProvider<BusinessProvider>.value(
          value: provider,
          child: const MaterialApp(home: BusinessListScreen()),
        ),
      );
      // trigger fetch
      provider.fetchBusinesses();
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Apple');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ReusableCard, 'Apple'), findsOneWidget);
      expect(find.widgetWithText(ReusableCard, 'Banana'), findsNothing);
      expect(find.widgetWithText(ReusableCard, 'Orange'), findsNothing);

      // Clear search query
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ReusableCard, 'Apple'), findsOneWidget);
      expect(find.widgetWithText(ReusableCard, 'Banana'), findsOneWidget);
      expect(find.widgetWithText(ReusableCard, 'Orange'), findsOneWidget);
    });
  });
}
