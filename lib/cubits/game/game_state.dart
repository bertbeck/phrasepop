import 'package:equatable/equatable.dart';
import 'package:primio_app/models/game_result.dart';
import 'package:primio_app/models/phrase.dart';

enum GameStatus { initial, playing, won, lost }

class GameState extends Equatable {
  final Phrase? phrase;
  final Set<int> revealedIndices;
  final int score;
  final int lettersRevealed;
  final bool hintUsed;
  final int wrongGuesses;
  final GameStatus status;
  final String? feedbackMessage;
  final GameResult? result;

  const GameState({
    this.phrase,
    this.revealedIndices = const {},
    this.score = 1000,
    this.lettersRevealed = 0,
    this.hintUsed = false,
    this.wrongGuesses = 0,
    this.status = GameStatus.initial,
    this.feedbackMessage,
    this.result,
  });

  bool get allLettersRevealed {
    if (phrase == null) return false;
    for (int i = 0; i < phrase!.text.length; i++) {
      if (phrase!.text[i] != ' ' && !revealedIndices.contains(i)) return false;
    }
    return true;
  }

  GameState copyWith({
    Phrase? phrase,
    Set<int>? revealedIndices,
    int? score,
    int? lettersRevealed,
    bool? hintUsed,
    int? wrongGuesses,
    GameStatus? status,
    String? feedbackMessage,
    GameResult? result,
  }) =>
      GameState(
        phrase: phrase ?? this.phrase,
        revealedIndices: revealedIndices ?? this.revealedIndices,
        score: score ?? this.score,
        lettersRevealed: lettersRevealed ?? this.lettersRevealed,
        hintUsed: hintUsed ?? this.hintUsed,
        wrongGuesses: wrongGuesses ?? this.wrongGuesses,
        status: status ?? this.status,
        feedbackMessage: feedbackMessage ?? this.feedbackMessage,
        result: result ?? this.result,
      );

  @override
  List<Object?> get props => [
        phrase,
        revealedIndices,
        score,
        lettersRevealed,
        hintUsed,
        wrongGuesses,
        status,
        feedbackMessage,
        result,
      ];
}
