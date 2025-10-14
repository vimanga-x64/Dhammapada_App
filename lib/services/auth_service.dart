import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class AuthService extends ChangeNotifier {
  static const String _authBoxName = 'auth';
  static const String _isSignedInKey = 'isSignedIn';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';

  bool _isSignedIn = false;
  String _userName = 'Seeker';
  String? _userEmail;

  AuthService() {
    _loadAuthState();
  }

  bool get isSignedIn => _isSignedIn;
  String get displayName => _userName;
  String? get userEmail => _userEmail;
  
  String get greeting {
    final hour = DateTime.now().hour;
    String timeGreeting;
    
    if (hour < 12) {
      timeGreeting = 'Good morning';
    } else if (hour < 17) {
      timeGreeting = 'Good afternoon';
    } else {
      timeGreeting = 'Good evening';
    }
    
    return '$timeGreeting, $displayName';
  }

  Future<void> _loadAuthState() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      _isSignedIn = box.get(_isSignedInKey, defaultValue: false);
      _userName = box.get(_userNameKey, defaultValue: 'Seeker');
      _userEmail = box.get(_userEmailKey);
      notifyListeners();
    } catch (e) {
      print('Error loading auth state: $e');
    }
  }

  Future<void> _saveAuthState() async {
    try {
      final box = await Hive.openBox(_authBoxName);
      await box.put(_isSignedInKey, _isSignedIn);
      await box.put(_userNameKey, _userName);
      if (_userEmail != null) {
        await box.put(_userEmailKey, _userEmail);
      }
    } catch (e) {
      print('Error saving auth state: $e');
    }
  }

  // Mock sign in methods for UI testing
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation (accept any non-empty credentials)
      if (email.isNotEmpty && password.isNotEmpty) {
        _isSignedIn = true;
        _userEmail = email;
        _userName = email.split('@').first.split('.').map((part) =>
            part[0].toUpperCase() + part.substring(1)).join(' ');
        
        await _saveAuthState();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password, String name) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        _isSignedIn = true;
        _userEmail = email;
        _userName = name;
        
        await _saveAuthState();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock Google sign in
      _isSignedIn = true;
      _userName = 'Google User';
      _userEmail = 'user@gmail.com';
      
      await _saveAuthState();
      notifyListeners();
      return true;
    } catch (e) {
      print('Google sign in error: $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock Apple sign in
      _isSignedIn = true;
      _userName = 'Apple User';
      _userEmail = 'user@icloud.com';
      
      await _saveAuthState();
      notifyListeners();
      return true;
    } catch (e) {
      print('Apple sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    _userName = 'Seeker';
    _userEmail = null;
    
    await _saveAuthState();
    notifyListeners();
  }

  // Helper method for testing
  Future<void> simulateSignIn(String name, [String? email]) async {
    _isSignedIn = true;
    _userName = name;
    _userEmail = email;
    
    await _saveAuthState();
    notifyListeners();
  }
}