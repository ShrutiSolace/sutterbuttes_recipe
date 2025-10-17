import 'package:flutter/foundation.dart';
import '../../modal/about_us_model.dart';
import '../../repositories/about_us_repository.dart';



class AboutContentProvider with ChangeNotifier {
  AboutContentModel? _aboutContent;
  bool _isLoading = false;
  String? _error;

  AboutContentModel? get aboutContent => _aboutContent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final AboutContentRepository _repository = AboutContentRepository();

  Future<void> fetchAboutContent() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _aboutContent = await _repository.getAboutContent();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}