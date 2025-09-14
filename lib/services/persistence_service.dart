import 'dart:convert';

import 'package:business_card_app/models/business.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const _key = "businesses_data";

  Future<void> saveBusinessData(List<Business> businesses) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> businessJsonList = businesses
        .map((b) => json.encode(b.toJson()))
        .toList();
    await prefs.setStringList(_key, businessJsonList);
  }

  Future<List<Business>> loadBusinessData() async {
    final prefs = await SharedPreferences.getInstance();
    final businessJsonList = prefs.getStringList(_key);
    if (businessJsonList == null) {
      return [];
    }
    return businessJsonList
        .map((jsonStr) {
          try {
            return Business.fromJson(json.decode(jsonStr));
          } catch (e) {
            return null;
          }
        })
        .whereType<Business>()
        .toList();
  }
}
