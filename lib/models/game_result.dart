import 'package:equatable/equatable.dart';

class GameResult extends Equatable {
  final int score;
  final int lettersRevealed;
  final bool hintsUsed;
  final int wrongGuesses;
  final bool solved;
  final String phrase;
  final String category;

  const GameResult({
    required this.score,
    required this.lettersRevealed,
    required this.hintsUsed,
    required this.wrongGuesses,
    required this.solved,
    required this.phrase,
    required this.category,
  });

  int get stars {
    if (!solved) return 0;
    if (score >= 800) return 3;
    if (score >= 500) return 2;
    return 1;
  }

  @override
  List<Object?> get props => [score, lettersRevealed, hintsUsed, wrongGuesses, solved, phrase, category];
}
