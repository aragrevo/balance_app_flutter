import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  GoogleSignInAccount? user;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      _isLoading = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      user = googleUser;
      return googleUser;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
