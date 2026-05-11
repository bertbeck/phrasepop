import 'package:equatable/equatable.dart';

enum PhraseCategory {
  movies('Movies', '🎬'),
  famousSayings('Famous Sayings', '💬'),
  popCulture('Pop Culture', '🌟'),
  places('Places', '🌍'),
  food('Food', '🍕'),
  sports('Sports', '⚽'),
  random('Random', '🎲');

  const PhraseCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

enum PhraseDifficulty { easy, medium, hard }

class Phrase extends Equatable {
  final String id;
  final String text;
  final PhraseCategory category;
  final String hint;
  final PhraseDifficulty difficulty;

  const Phrase({
    required this.id,
    required this.text,
    required this.category,
    required this.hint,
    required this.difficulty,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) => Phrase(
        id: json['id'] as String,
        text: json['text'] as String,
        category: PhraseCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => PhraseCategory.random,
        ),
        hint: json['hint'] as String,
        difficulty: PhraseDifficulty.values.firstWhere(
          (d) => d.name == json['difficulty'],
          orElse: () => PhraseDifficulty.medium,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'category': category.name,
        'hint': hint,
        'difficulty': difficulty.name,
      };

  @override
  List<Object?> get props => [id, text, category, hint, difficulty];
}
