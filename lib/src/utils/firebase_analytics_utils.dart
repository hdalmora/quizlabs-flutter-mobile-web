import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FirebaseAnalyticsUtils {
  static FirebaseAnalyticsUtils get instance => _analyticsInstance ??= FirebaseAnalyticsUtils();
  static FirebaseAnalyticsUtils _analyticsInstance;

  static FirebaseAnalytics _analytics;
  static FirebaseAnalyticsObserver _observer;

  static FirebaseAnalytics get analytics => _analytics;
  static FirebaseAnalyticsObserver get observer => _observer;

  static FirebaseAnalyticsUtils init() {
    _analyticsInstance = instance;
    _analytics = FirebaseAnalytics();
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
    return _analyticsInstance;
  }
}