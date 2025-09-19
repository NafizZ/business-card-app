import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:business_card_app/features/business_discovery/presentation/screens/business_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusinessDetailScreen', () {
    final tBusiness = const Business(
      name: 'Test Business',
      location: 'Test Location',
      contactNumber: '1234567890',
    );

    testWidgets('displays business details correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: BusinessDetailScreen(business: tBusiness)),
      );

      // AppBar title + body label -> two occurrences
      expect(find.text('Test Business'), findsNWidgets(2));
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);

      expect(find.byIcon(Icons.business), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });
  });
}
