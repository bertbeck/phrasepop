import 'package:equatable/equatable.dart';

/// Represents the possible states of the startup / intro visibility flow.
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial state — preferences are being loaded.
class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Preferences loaded. [showIntro] drives routing.
class SplashReady extends SplashState {
  /// Whether the intro page should be shown on this launch.
  /// True on every launch unless the user ticked "Don't show again".
  final bool showIntro;

  const SplashReady({required this.showIntro});

  @override
  List<Object?> get props => [showIntro];
}
