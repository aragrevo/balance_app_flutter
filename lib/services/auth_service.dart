import 'package:balance_app/models/balance_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Account {
  GoogleSignInAccount? googleUser;
  Money? money;
  Account({required this.googleUser, this.money});
}

class AuthService with ChangeNotifier {
  Account? account;
  bool isLoading = false;
  GoogleSignInAccount? get user => account?.googleUser;

  Money? get money => account?.money;
  set money(Money? value) {
    account?.money = value;
    notifyListeners();
  }

  bool get isEuro => money == Money.eur;

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
      account ??= Account(googleUser: googleUser!, money: Money.eur);
      account?.googleUser = googleUser;
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
      // account = Account(googleUser: googleUser!);
      account?.googleUser = googleUser;
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
