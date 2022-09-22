import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  GoogleSignInAccount? user;
  bool isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      user = googleUser;
      return googleUser;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<GoogleSignInAccount?> signOut() async {
    try {
      isLoading = true;
      notifyListeners();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signOut();
      user = googleUser;
      return googleUser;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
