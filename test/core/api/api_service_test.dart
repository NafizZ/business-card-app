import 'package:business_card_app/core/api/api_service.dart';
import 'package:business_card_app/core/api/dio_client.dart';
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple fake DioClient to avoid Mockito null-safety issues in tests.
class FakeDioClient implements DioClient {
  Future<Response<dynamic>> Function<T>(String path)? onGet;

  @override
  Future<Response<T>> get<T>(String path) async {
    if (onGet != null) {
      final resp = await onGet!.call<T>(path);
      return resp as Response<T>;
    }
    throw UnimplementedError('onGet not set');
  }
}

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late FakeDioClient fakeDioClient;

    setUp(() {
      fakeDioClient = FakeDioClient();
      apiService = ApiService(fakeDioClient);
    });

    final tBusinessJson = {
      'biz_name': 'Test Business',
      'bss_location': 'Test Location',
      'contct_no': '1234567890',
    };

    final tBusiness = Business.fromJson(tBusinessJson);

    test(
      'should return a list of businesses when the call is successful',
      () async {
        // arrange
        fakeDioClient.onGet = <T>(String path) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ''),
          data: [tBusinessJson],
          statusCode: 200,
        );

        // act
        final result = await apiService.fetchBusinesses();

        // assert
        expect(result, [tBusiness]);
      },
    );

    test('should throw an exception when the call is unsuccessful', () async {
      // arrange
      fakeDioClient.onGet = <T>(String path) async => throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Error',
      );

      // act
      final call = apiService.fetchBusinesses;

      // assert
      expect(() => call(), throwsA(isA<Exception>()));
    });

    test('should filter out malformed business data', () async {
      // arrange
      final malformedJson = {
        'biz_name': 'Malformed Business',
        // Missing location and contact number
      };
      fakeDioClient.onGet = <T>(String path) async => Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [tBusinessJson, malformedJson],
        statusCode: 200,
      );

      // act
      final result = await apiService.fetchBusinesses();

      // assert
      expect(result, [tBusiness]);
      expect(result.length, 1);
    });
  });
}
