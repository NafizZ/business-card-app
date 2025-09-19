
import 'package:business_card_app/providers/business_provider.dart';
import 'package:business_card_app/services/api_service.dart';
import 'package:business_card_app/services/business_repository.dart';
import 'package:business_card_app/services/local_data_interceptor.dart';
import 'package:business_card_app/services/persistence_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(LocalDataInterceptor());
    return dio;
  });
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));
  sl.registerLazySingleton<PersistenceService>(() => PersistenceService());
  sl.registerLazySingleton<BusinessRepository>(
      () => BusinessRepository(sl<ApiService>(), sl<PersistenceService>()));

  // Providers
  sl.registerFactory<BusinessProvider>(
      () => BusinessProvider(sl<BusinessRepository>()));
}
