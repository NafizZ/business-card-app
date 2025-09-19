
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:business_card_app/features/business_discovery/data/repositories/business_repository.dart';
import 'package:flutter/material.dart';


enum AppState { initial, loading, success, error }

class BusinessProvider with ChangeNotifier {
  final BusinessRepository _repository;

  BusinessProvider(this._repository) {
    fetchBusinesses();
  }

  AppState _state = AppState.initial;
  AppState get state => _state;

  List<Business> _businesses = [];
  List<Business> get businesses => _businesses;

  List<Business> _filteredBusinesses = [];
  List<Business> get filteredBusinesses => _filteredBusinesses;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Future<void> fetchBusinesses() async {
    _state = AppState.loading;
    notifyListeners();

    try {
      _businesses = await _repository.getBusinesses();
      _filteredBusinesses = _businesses;
      _state = AppState.success;
    } catch (e) {
      _state = AppState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredBusinesses = _businesses;
    } else {
      _filteredBusinesses = _businesses
          .where(
            (b) =>
                b.name.toLowerCase().contains(query.toLowerCase()) ||
                b.location.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
