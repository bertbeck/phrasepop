import 'dart:math';

/// Core game business logic — scoring rules, letter reveals, answer validation.
class GameService {
  static const int startingScore = 1000;
  static const int revealPenalty = 100;
  static const int hintPenalty = 200;
  static const int wrongGuessPenalty = 50;
  static const int minimumScore = 100;

  final _random = Random();

  /// Calculate score after penalties
  int calculateScore({
    required int lettersRevealed,
    required bool hintUsed,
    required int wrongGuesses,
  }) {
    int score = startingScore;
    score -= lettersRevealed * revealPenalty;
    if (hintUsed) score -= hintPenalty;
    score -= wrongGuesses * wrongGuessPenalty;
    return score.clamp(minimumScore, startingScore);
  }

  /// Generate initial set of revealed letter indices (about 30% of unique letters)
  Set<int> generateStarterLetters(String phrase) {
    final letterIndices = <int>[];
    for (int i = 0; i < phrase.length; i++) {
      if (phrase[i] != ' ') letterIndices.add(i);
    }

    final revealCount = (letterIndices.length * 0.3).ceil();
    letterIndices.shuffle(_random);
    return letterIndices.take(revealCount).toSet();
  }

  /// Check if the player's guess matches
  bool checkAnswer(String guess, String answer) {
    return guess.trim().toUpperCase() == answer.toUpperCase();
  }

  /// Reveal one random hidden letter, returns its index or -1 if all revealed
  int revealNextLetter(String phrase, Set<int> revealedIndices) {
    final hiddenIndices = <int>[];
    for (int i = 0; i < phrase.length; i++) {
      if (phrase[i] != ' ' && !revealedIndices.contains(i)) {
        hiddenIndices.add(i);
      }
    }
    if (hiddenIndices.isEmpty) return -1;
    return hiddenIndices[_random.nextInt(hiddenIndices.length)];
  }
}
