import 'package:business_card_app/models/business.dart';
import 'package:business_card_app/services/api_service.dart';
import 'package:business_card_app/services/persistence_service.dart';

class BusinessRepository {
  final ApiService _apiService;
  final PersistenceService _persistenceService;

  BusinessRepository(this._apiService, this._persistenceService);

  Future<List<Business>> getBusinesses() async {
    try {
      final businesses = await _apiService.fetchBusinesses();
      await _persistenceService.saveBusinessData(businesses);
      return businesses;
    } catch (e) {
      // If API fails, try loading from cache
      final cachedBusinesses = await _persistenceService.loadBusinessData();
      if (cachedBusinesses.isNotEmpty) {
        return cachedBusinesses;
      }
      // If cache is also empty, rethrow the error
      rethrow;
    }
  }
}
