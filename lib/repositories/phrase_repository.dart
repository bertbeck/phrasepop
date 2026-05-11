import 'dart:math';

import 'package:primio_app/models/phrase.dart';

class PhraseRepository {
  final _random = Random();

  static const List<Phrase> _localPhrases = [
    // Movies
    Phrase(id: '1', text: 'MAY THE FORCE BE WITH YOU', category: PhraseCategory.movies, hint: 'A galactic farewell', difficulty: PhraseDifficulty.easy),
    Phrase(id: '2', text: 'HERE IS LOOKING AT YOU KID', category: PhraseCategory.movies, hint: 'Classic Bogart line', difficulty: PhraseDifficulty.medium),
    Phrase(id: '3', text: 'I WILL BE BACK', category: PhraseCategory.movies, hint: 'Famous Arnold promise', difficulty: PhraseDifficulty.easy),
    Phrase(id: '4', text: 'TO INFINITY AND BEYOND', category: PhraseCategory.movies, hint: 'A space ranger motto', difficulty: PhraseDifficulty.easy),
    Phrase(id: '5', text: 'LIFE IS LIKE A BOX OF CHOCOLATES', category: PhraseCategory.movies, hint: 'Forrest wisdom', difficulty: PhraseDifficulty.medium),
    Phrase(id: '6', text: 'JUST KEEP SWIMMING', category: PhraseCategory.movies, hint: 'Dory advice', difficulty: PhraseDifficulty.easy),
    Phrase(id: '7', text: 'YOU SHALL NOT PASS', category: PhraseCategory.movies, hint: 'A wizard stands firm', difficulty: PhraseDifficulty.easy),
    Phrase(id: '8', text: 'HOUSTON WE HAVE A PROBLEM', category: PhraseCategory.movies, hint: 'Space trouble', difficulty: PhraseDifficulty.medium),

    // Famous Sayings
    Phrase(id: '9', text: 'ACTIONS SPEAK LOUDER THAN WORDS', category: PhraseCategory.famousSayings, hint: 'Doing beats talking', difficulty: PhraseDifficulty.medium),
    Phrase(id: '10', text: 'THE EARLY BIRD CATCHES THE WORM', category: PhraseCategory.famousSayings, hint: 'Rise and shine', difficulty: PhraseDifficulty.medium),
    Phrase(id: '11', text: 'KNOWLEDGE IS POWER', category: PhraseCategory.famousSayings, hint: 'Francis Bacon said it', difficulty: PhraseDifficulty.easy),
    Phrase(id: '12', text: 'PRACTICE MAKES PERFECT', category: PhraseCategory.famousSayings, hint: 'Keep at it', difficulty: PhraseDifficulty.easy),
    Phrase(id: '13', text: 'WHEN IN ROME DO AS THE ROMANS DO', category: PhraseCategory.famousSayings, hint: 'Blend in with locals', difficulty: PhraseDifficulty.hard),
    Phrase(id: '14', text: 'EVERY CLOUD HAS A SILVER LINING', category: PhraseCategory.famousSayings, hint: 'Optimistic outlook', difficulty: PhraseDifficulty.medium),
    Phrase(id: '15', text: 'ALL THAT GLITTERS IS NOT GOLD', category: PhraseCategory.famousSayings, hint: 'Shakespeare knew it', difficulty: PhraseDifficulty.medium),
    Phrase(id: '16', text: 'CARPE DIEM', category: PhraseCategory.famousSayings, hint: 'Latin for live now', difficulty: PhraseDifficulty.easy),

    // Pop Culture
    Phrase(id: '17', text: 'WINTER IS COMING', category: PhraseCategory.popCulture, hint: 'Stark family words', difficulty: PhraseDifficulty.easy),
    Phrase(id: '18', text: 'THAT IS WHAT SHE SAID', category: PhraseCategory.popCulture, hint: 'Michael Scott classic', difficulty: PhraseDifficulty.easy),
    Phrase(id: '19', text: 'I AM IRON MAN', category: PhraseCategory.popCulture, hint: 'Marvel snap', difficulty: PhraseDifficulty.easy),
    Phrase(id: '20', text: 'THIS IS THE WAY', category: PhraseCategory.popCulture, hint: 'Mandalorian creed', difficulty: PhraseDifficulty.easy),
    Phrase(id: '21', text: 'BAZINGA', category: PhraseCategory.popCulture, hint: 'Sheldon catchphrase', difficulty: PhraseDifficulty.easy),
    Phrase(id: '22', text: 'HOW YOU DOIN', category: PhraseCategory.popCulture, hint: 'Joey Tribbiani greeting', difficulty: PhraseDifficulty.easy),
    Phrase(id: '23', text: 'LIVE LONG AND PROSPER', category: PhraseCategory.popCulture, hint: 'Vulcan salute', difficulty: PhraseDifficulty.medium),

    // Places
    Phrase(id: '24', text: 'NEW YORK CITY', category: PhraseCategory.places, hint: 'The Big Apple', difficulty: PhraseDifficulty.easy),
    Phrase(id: '25', text: 'GREAT WALL OF CHINA', category: PhraseCategory.places, hint: 'Visible from space myth', difficulty: PhraseDifficulty.medium),
    Phrase(id: '26', text: 'MACHU PICCHU', category: PhraseCategory.places, hint: 'Incan citadel in Peru', difficulty: PhraseDifficulty.medium),
    Phrase(id: '27', text: 'NIAGARA FALLS', category: PhraseCategory.places, hint: 'Border waterfall', difficulty: PhraseDifficulty.easy),
    Phrase(id: '28', text: 'GRAND CANYON', category: PhraseCategory.places, hint: 'Arizona gorge', difficulty: PhraseDifficulty.easy),
    Phrase(id: '29', text: 'EIFFEL TOWER', category: PhraseCategory.places, hint: 'Iron lady of Paris', difficulty: PhraseDifficulty.easy),
    Phrase(id: '30', text: 'MOUNT EVEREST', category: PhraseCategory.places, hint: 'Top of the world', difficulty: PhraseDifficulty.easy),
    Phrase(id: '31', text: 'SYDNEY OPERA HOUSE', category: PhraseCategory.places, hint: 'Sail-shaped landmark', difficulty: PhraseDifficulty.medium),

    // Food
    Phrase(id: '32', text: 'PEANUT BUTTER AND JELLY', category: PhraseCategory.food, hint: 'Classic sandwich duo', difficulty: PhraseDifficulty.easy),
    Phrase(id: '33', text: 'CHICKEN TIKKA MASALA', category: PhraseCategory.food, hint: 'Creamy curry dish', difficulty: PhraseDifficulty.medium),
    Phrase(id: '34', text: 'SPAGHETTI AND MEATBALLS', category: PhraseCategory.food, hint: 'Italian-American classic', difficulty: PhraseDifficulty.easy),
    Phrase(id: '35', text: 'FISH AND CHIPS', category: PhraseCategory.food, hint: 'British takeaway', difficulty: PhraseDifficulty.easy),
    Phrase(id: '36', text: 'CHOCOLATE CHIP COOKIES', category: PhraseCategory.food, hint: 'Fresh from the oven', difficulty: PhraseDifficulty.easy),
    Phrase(id: '37', text: 'EGGS BENEDICT', category: PhraseCategory.food, hint: 'Fancy brunch order', difficulty: PhraseDifficulty.medium),
    Phrase(id: '38', text: 'AVOCADO TOAST', category: PhraseCategory.food, hint: 'Millennial favorite', difficulty: PhraseDifficulty.easy),

    // Sports
    Phrase(id: '39', text: 'SLAM DUNK', category: PhraseCategory.sports, hint: 'Basketball power move', difficulty: PhraseDifficulty.easy),
    Phrase(id: '40', text: 'HOLE IN ONE', category: PhraseCategory.sports, hint: 'Golfer dream shot', difficulty: PhraseDifficulty.easy),
    Phrase(id: '41', text: 'SUDDEN DEATH OVERTIME', category: PhraseCategory.sports, hint: 'Next goal wins', difficulty: PhraseDifficulty.medium),
    Phrase(id: '42', text: 'WORLD CUP FINAL', category: PhraseCategory.sports, hint: 'Biggest soccer match', difficulty: PhraseDifficulty.easy),
    Phrase(id: '43', text: 'TRIPLE DOUBLE', category: PhraseCategory.sports, hint: 'Basketball stat feat', difficulty: PhraseDifficulty.medium),
    Phrase(id: '44', text: 'HOME RUN', category: PhraseCategory.sports, hint: 'Out of the park', difficulty: PhraseDifficulty.easy),
    Phrase(id: '45', text: 'CHECKMATE', category: PhraseCategory.sports, hint: 'King is trapped', difficulty: PhraseDifficulty.easy),

    // Random
    Phrase(id: '46', text: 'BREAK A LEG', category: PhraseCategory.random, hint: 'Good luck on stage', difficulty: PhraseDifficulty.easy),
    Phrase(id: '47', text: 'ONCE IN A BLUE MOON', category: PhraseCategory.random, hint: 'Very rarely', difficulty: PhraseDifficulty.medium),
    Phrase(id: '48', text: 'CURIOSITY KILLED THE CAT', category: PhraseCategory.random, hint: 'Too nosy', difficulty: PhraseDifficulty.medium),
    Phrase(id: '49', text: 'BURNING THE MIDNIGHT OIL', category: PhraseCategory.random, hint: 'Working late', difficulty: PhraseDifficulty.medium),
    Phrase(id: '50', text: 'PIECE OF CAKE', category: PhraseCategory.random, hint: 'Super easy', difficulty: PhraseDifficulty.easy),
    Phrase(id: '51', text: 'BACK TO SQUARE ONE', category: PhraseCategory.random, hint: 'Start over', difficulty: PhraseDifficulty.medium),
    Phrase(id: '52', text: 'BLESSING IN DISGUISE', category: PhraseCategory.random, hint: 'Hidden good fortune', difficulty: PhraseDifficulty.medium),
    Phrase(id: '53', text: 'COST AN ARM AND A LEG', category: PhraseCategory.random, hint: 'Very expensive', difficulty: PhraseDifficulty.medium),
    Phrase(id: '54', text: 'UNDER THE WEATHER', category: PhraseCategory.random, hint: 'Feeling sick', difficulty: PhraseDifficulty.easy),
    Phrase(id: '55', text: 'THE BEST OF BOTH WORLDS', category: PhraseCategory.random, hint: 'Everything you want', difficulty: PhraseDifficulty.medium),
  ];

  List<Phrase> getAllPhrases() => List.unmodifiable(_localPhrases);

  List<Phrase> getPhrasesByCategory(PhraseCategory category) =>
      _localPhrases.where((p) => p.category == category).toList();

  Phrase getRandomPhrase({PhraseCategory? category}) {
    final pool = category != null ? getPhrasesByCategory(category) : _localPhrases;
    return pool[_random.nextInt(pool.length)];
  }

  Phrase? getDailyPhrase() {
    // Simple deterministic daily phrase based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _localPhrases[dayOfYear % _localPhrases.length];
  }
}
