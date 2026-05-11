import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primio_app/features/splash/cubit/splash_state.dart';
import 'package:primio_app/features/splash/data/splash_preferences.dart';

/// Manages the one-time intro page visibility logic.
///
/// Responsibilities:
///   1. Load SharedPreferences once at startup.
///   2. Increment the launch counter exactly once per cold start.
///   3. Emit [SplashReady] with [showIntro] so the router can decide
///      whether to show the intro page or go straight to /home.
///   4. Expose [dismissIntro] so the user can persist "Don't show again".
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashLoading());

  /// Called once when the app starts (inside SplashScreen.initState).
  /// Loads prefs then emits the routing decision.
  Future<void> initialize() async {
    // Load SharedPreferences — safe to call multiple times (cached internally).
    await SplashPreferences.load();

    // Show intro on every launch unless the user has opted out.
    emit(SplashReady(showIntro: SplashPreferences.shouldShowIntro));
  }

  /// Called by the intro page when the user taps "Start Playing".
  ///
  /// [dontShowAgain] — when true, permanently suppresses the intro.
  Future<void> dismissIntro({required bool dontShowAgain}) async {
    if (dontShowAgain) {
      await SplashPreferences.setHideSplash(true);
    }
  }
}
