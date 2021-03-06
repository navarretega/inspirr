import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({
    @required this.uid,
    @required this.email,
    @required this.isVerified,
    @required this.isAnonymous,
    @required this.provider,
  });

  final String uid;
  final String email;
  final bool isVerified;
  final bool isAnonymous;
  final String provider;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<User> signInWithGoogle();

  // Future<User> signInWithFacebook();
  Future<void> signOut();

  Future<void> resetPassword(String email);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  String _provId;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    try {
      _provId = user.providerData[1].providerId;
    } catch (e) {
      _provId = '';
    }
    return User(
      uid: user.uid,
      email: user.email,
      isVerified: user.isEmailVerified,
      isAnonymous: user.isAnonymous,
      provider: _provId,
    );
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (authResult.user.isEmailVerified) {
      return _userFromFirebase(authResult.user);
    } else {
      return _userFromFirebase(null);
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await authResult.user.sendEmailVerification();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

//  @override
//  Future<User> signInWithFacebook() async {
//    final facebookLogin = FacebookLogin();
//    final result = await facebookLogin.logIn(
//      ['public_profile', 'email'],
//    );
//    if (result.accessToken != null) {
//      final authResult = await _firebaseAuth.signInWithCredential(
//        FacebookAuthProvider.getCredential(
//          accessToken: result.accessToken.token,
//        ),
//      );
//      return _userFromFirebase(authResult.user);
//    } else {
//      throw PlatformException(
//        code: 'ERROR_ABORTED_BY_USER',
//        message: 'Sign in aborted by user',
//      );
//    }
//  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    // final facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
