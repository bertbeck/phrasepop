/// REST API client scaffold for future Golang backend integration.
/// All endpoints are defined but not operational for MVP.
class ApiClient {
  static const String baseUrl = 'https://api.phrasepop.com/v1';

  // Auth endpoints
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String loginEndpoint = '$baseUrl/auth/login';

  // Phrase endpoints
  static const String phrasesEndpoint = '$baseUrl/phrases';
  static const String dailyPhraseEndpoint = '$baseUrl/phrases/daily';

  // Score endpoints
  static const String scoresEndpoint = '$baseUrl/scores';
  static const String leaderboardEndpoint = '$baseUrl/leaderboard';

  // Profile endpoint
  static const String profileEndpoint = '$baseUrl/profile';
}
