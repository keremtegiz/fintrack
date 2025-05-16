import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  // Firebase olmadan test amacıyla Mock auth
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSignedIn = true; // Test için otomatik giriş yapmış kabul ediyoruz
  String? _userId = "test_user_id";

  // Geçerli kullanıcıyı al
  User? get currentUser => null; // Mock için null

  // Kullanıcının oturum açıp açmadığını kontrol et
  bool get isSignedIn => _isSignedIn;

  // Kullanıcı durumu değişikliklerini dinle
  Stream<User?> get authStateChanges =>
      Stream.value(null); // Mock için boş stream

  // E-posta ve şifre ile kayıt ol
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    // Mock işlem
    _isSignedIn = true;
    notifyListeners();
    return null;
  }

  // E-posta ve şifre ile giriş yap
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    // Mock işlem
    _isSignedIn = true;
    notifyListeners();
    return null;
  }

  // Şifre sıfırlama maili gönder
  Future<void> sendPasswordResetEmail(String email) async {
    // Mock işlem
    return;
  }

  // Oturumu kapat
  Future<void> signOut() async {
    _isSignedIn = false;
    notifyListeners();
  }
}
