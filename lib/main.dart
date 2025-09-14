import 'package:business_card_app/providers/business_provider.dart';
import 'package:business_card_app/screens/business_list_screen.dart';
import 'package:business_card_app/services/api_service.dart';
import 'package:business_card_app/services/business_repository.dart';
import 'package:business_card_app/services/local_data_interceptor.dart';
import 'package:business_card_app/services/persistence_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final dio = Dio()..interceptors.add(LocalDataInterceptor());
  final apiService = ApiService(dio);
  final persistenceService = PersistenceService();
  final businessRepository = BusinessRepository(apiService, persistenceService);

  runApp(
    ChangeNotifierProvider(
      create: (context) => BusinessProvider(businessRepository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Card App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const BusinessListScreen(),
    );
  }
}
