import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/cubits/game/game_cubit.dart';
import 'package:primio_app/features/splash/cubit/splash_cubit.dart';
import 'package:primio_app/features/splash/presentation/phrasepop_intro_page.dart';
import 'package:primio_app/models/game_result.dart';
import 'package:primio_app/models/phrase.dart';
import 'package:primio_app/repositories/phrase_repository.dart';
import 'package:primio_app/screens/game_screen.dart';
import 'package:primio_app/screens/home_screen.dart';
import 'package:primio_app/screens/login_screen.dart';
import 'package:primio_app/screens/results_screen.dart';
import 'package:primio_app/screens/splash_screen.dart';
import 'package:primio_app/services/game_service.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // ── Startup splash (logo reveal, ~3 s) ───────────────────────────────
      // SplashScreen owns the SplashCubit: it initialises prefs, increments
      // the launch count, and then routes to /intro or /home accordingly.
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) => SplashCubit(),
          child: const SplashScreen(),
        ),
      ),

      // ── First-launch intro / onboarding page ─────────────────────────────
      // The SplashCubit created in '/' navigates here when shouldShowIntro
      // is true. A fresh SplashCubit is provided so this route is self-
      // contained (e.g. deep-linked or re-visited from a test).
      GoRoute(
        path: '/intro',
        builder: (context, state) => BlocProvider(
          create: (_) => SplashCubit(),
          child: const PhrasepopIntroPage(),
        ),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) {
          final category = state.extra as PhraseCategory?;
          return BlocProvider(
            create: (_) => GameCubit(
              phraseRepository: PhraseRepository(),
              gameService: GameService(),
            )..startGame(category: category),
            child: const GameScreen(),
          );
        },
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          final result = state.extra as GameResult;
          return ResultsScreen(result: result);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
