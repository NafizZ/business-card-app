import 'package:business_card_app/core/api/dio_client.dart';
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:dio/dio.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);
  Future<List<Business>> fetchBusinesses() async {
    try {
      final response = await _dioClient.get('/businesses');

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
