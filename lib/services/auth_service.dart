/// Mock auth service — prepared for REST backend integration.
/// For MVP, all auth operations are simulated locally.
class AuthService {
  bool _isLoggedIn = false;
  String? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _currentUser = email;
    return true;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _currentUser = email;
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoggedIn = false;
    _currentUser = null;
  }

  Future<void> continueAsGuest() async {
    _isLoggedIn = false;
    _currentUser = 'Guest';
  }
}
