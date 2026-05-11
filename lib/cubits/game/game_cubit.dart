import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primio_app/cubits/game/game_state.dart';
import 'package:primio_app/models/game_result.dart';
import 'package:primio_app/models/phrase.dart';
import 'package:primio_app/repositories/phrase_repository.dart';
import 'package:primio_app/services/game_service.dart';

class GameCubit extends Cubit<GameState> {
  final PhraseRepository _phraseRepository;
  final GameService _gameService;

  GameCubit({
    required PhraseRepository phraseRepository,
    required GameService gameService,
  })  : _phraseRepository = phraseRepository,
        _gameService = gameService,
        super(const GameState());

  /// Start a new round with optional category filter
  void startGame({PhraseCategory? category}) {
    final phrase = _phraseRepository.getRandomPhrase(category: category);
    final starterIndices = _gameService.generateStarterLetters(phrase.text);

    emit(GameState(
      phrase: phrase,
      revealedIndices: starterIndices,
      score: GameService.startingScore,
      status: GameStatus.playing,
    ));
  }

  /// Reveal one hidden letter, apply score penalty
  void revealLetter() {
    if (state.phrase == null || state.status != GameStatus.playing) return;
    if (state.allLettersRevealed) return;

    final newIndex = _gameService.revealNextLetter(
      state.phrase!.text,
      state.revealedIndices,
    );
    if (newIndex == -1) return;

    final newRevealed = {...state.revealedIndices, newIndex};
    final newLettersRevealed = state.lettersRevealed + 1;
    final newScore = _gameService.calculateScore(
      lettersRevealed: newLettersRevealed,
      hintUsed: state.hintUsed,
      wrongGuesses: state.wrongGuesses,
    );

    emit(state.copyWith(
      revealedIndices: newRevealed,
      lettersRevealed: newLettersRevealed,
      score: newScore,
      feedbackMessage: "That'll cost you points! 😬",
    ));
  }

  /// Show hint, apply score penalty
  void useHint() {
    if (state.phrase == null || state.status != GameStatus.playing) return;
    if (state.hintUsed) return;

    final newScore = _gameService.calculateScore(
      lettersRevealed: state.lettersRevealed,
      hintUsed: true,
      wrongGuesses: state.wrongGuesses,
    );

    emit(state.copyWith(
      hintUsed: true,
      score: newScore,
      feedbackMessage: state.phrase!.hint,
    ));
  }

  /// Submit a guess
  void submitGuess(String guess) {
    if (state.phrase == null || state.status != GameStatus.playing) return;
    if (guess.trim().isEmpty) return;

    final correct = _gameService.checkAnswer(guess, state.phrase!.text);

    if (correct) {
      final result = GameResult(
        score: state.score,
        lettersRevealed: state.lettersRevealed,
        hintsUsed: state.hintUsed,
        wrongGuesses: state.wrongGuesses,
        solved: true,
        phrase: state.phrase!.text,
        category: state.phrase!.category.label,
      );
      emit(state.copyWith(
        status: GameStatus.won,
        feedbackMessage: 'You nailed it! 🎉',
        result: result,
      ));
    } else {
      final newWrong = state.wrongGuesses + 1;
      final newScore = _gameService.calculateScore(
        lettersRevealed: state.lettersRevealed,
        hintUsed: state.hintUsed,
        wrongGuesses: newWrong,
      );

      emit(state.copyWith(
        wrongGuesses: newWrong,
        score: newScore,
        feedbackMessage: 'Nope! Try again 🤔',
      ));
    }
  }

  /// Give up — produce a failure result
  void giveUp() {
    if (state.phrase == null) return;
    final result = GameResult(
      score: 0,
      lettersRevealed: state.lettersRevealed,
      hintsUsed: state.hintUsed,
      wrongGuesses: state.wrongGuesses,
      solved: false,
      phrase: state.phrase!.text,
      category: state.phrase!.category.label,
    );
    emit(state.copyWith(
      status: GameStatus.lost,
      feedbackMessage: 'Brain = popped 🧠💥',
      result: result,
    ));
  }
}
