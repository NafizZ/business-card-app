
import 'package:business_card_app/core/api/api_service.dart';
import 'package:business_card_app/core/api/dio_client.dart';
import 'package:business_card_app/core/api/local_data_interceptor.dart';
import 'package:business_card_app/core/persistence/persistence_service.dart';
import 'package:business_card_app/features/business_discovery/data/repositories/business_repository.dart';
import 'package:business_card_app/features/business_discovery/presentation/providers/business_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Services
  sl.registerLazySingleton<DioClient>(() {
    final dio = Dio();
    dio.interceptors.add(LocalDataInterceptor());
    return DioClient(dio);
  });
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<DioClient>()));
  sl.registerLazySingleton<PersistenceService>(() => PersistenceService());
  sl.registerLazySingleton<BusinessRepository>(
      () => BusinessRepository(sl<ApiService>(), sl<PersistenceService>()));

  // Providers
  sl.registerFactory<BusinessProvider>(
      () => BusinessProvider(sl<BusinessRepository>()));
}
