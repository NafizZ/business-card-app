import 'package:business_card_app/models/business.dart';
import 'package:business_card_app/services/api_service.dart';

class BusinessRepository {
  final ApiService _apiService;

  BusinessRepository(this._apiService);

  Future<List<Business>> getBusinesses() async {
    try {
      final businesses = await _apiService.fetchBusinesses();
      return businesses;
    } catch (e) {
      throw Exception('Failed to fetch businesses: $e');
    }
  }
}
