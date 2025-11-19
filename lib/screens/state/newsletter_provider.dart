import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/modal/newsletter_model.dart';
import '../../repositories/newsletter_repository.dart';

class NewsletterProvider with ChangeNotifier {
  final NewsletterRepository _newsletterRepository;

  NewsletterProvider( this._newsletterRepository);

  NewsletterResponse? _newsletterData;
  bool _isLoading = false;
  String? _errorMessage;

  NewsletterResponse? get newsletterData => _newsletterData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  NewsletterSubscribeResponse? _subscribeResponse;
  NewsletterSubscribeResponse? get subscribeResponse => _subscribeResponse;




  // Fetch newsletter data with token
  Future<void> fetchNewsletterData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _newsletterRepository.getNewsletterData();
      _newsletterData = response;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error fetching newsletter data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear newsletter data
  void clearNewsletterData() {
    _newsletterData = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Retry fetching newsletter data
  Future<void> retryFetchNewsletterData({required String token}) async {
    await fetchNewsletterData();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }



  //subscribe
  Future<void> subscribeToNewsletter({
    required String email,
    required String name,
    required bool newRecipes,

    required bool seasonalOffers,
    required bool productUpdates,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscribeResponse = await _newsletterRepository.subscribeToNewsletter(
        email: email,
        name: name,
        newRecipes: newRecipes,

        seasonalOffers: seasonalOffers,
        productUpdates: productUpdates,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResponse() {
    _subscribeResponse = null;
    _errorMessage = null;
    notifyListeners();
  }

  //unsubscribe
  // Add this method to your existing NewsletterProvider class

  Future<void> unsubscribeFromNewsletter() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _newsletterRepository.unsubscribeFromNewsletter();

      // Handle success response
      if (response['success'] == true) {
        _subscribeResponse = null; // Clear subscription data
        _newsletterData = null; // Clear newsletter data
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }





}

























