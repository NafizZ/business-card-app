import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);
  Future<List<Business>> fetchBusinesses() async {
    try {
      final response = await _dio.get('/businesses');

      final List<dynamic> jsonList = response.data;

      return jsonList
          .map((json) {
            try {
              return Business.fromJson(json);
            } catch (e) {
              return null;
            }
          })
          .whereType<Business>()
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load businesses: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
