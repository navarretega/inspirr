import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:inspirr/services/auth.dart';

enum FormType { signIn, register, forgotPassword }

class EmailSignInModel with ChangeNotifier {
  String email;
  String password;
  String passwordVerify;
  FormType formType;
  bool isLoading;
  final AuthBase auth;

  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.passwordVerify = '',
    this.formType = FormType.signIn,
    this.isLoading = false,
    @required this.auth,
  });

  Future<void> signInWithEmailAndPassword() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        updateWith(isLoading: true);
        final _user = await auth.signInWithEmailAndPassword(email, password);
        if (_user == null) {
          updateWith(isLoading: false);
          throw (PlatformException(
              code: 'UNVERIFIED_EMAIL',
              message: 'Verifica tu correo antes de iniciar sesión.'));
        }
      } catch (e) {
        updateWith(isLoading: false);
        rethrow;
      }
    } else {
      throw (PlatformException(
        code: 'EMPTY_EMAIL_PASSWORD',
        message: 'Ingresa un email y contraseña valido.',
      ));
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (email.isNotEmpty && password.isNotEmpty && passwordVerify.isNotEmpty) {
      if (password == passwordVerify) {
        try {
          updateWith(isLoading: true);
          await auth.createUserWithEmailAndPassword(email, password);
        } catch (e) {
          updateWith(isLoading: false);
          rethrow;
        }
      } else {
        throw (PlatformException(
            code: 'PASSWORDS_DONT_MATCH',
            message: 'Verifica que tu contraseña sea igual.'));
      }
    } else {
      throw (PlatformException(
        code: 'EMPTY_EMAIL_PASSWORD',
        message: 'Ingresa un email y contraseña valido.',
      ));
    }
  }

  Future<void> resetPassword() async {
    if (email.isNotEmpty) {
      try {
        await auth.resetPassword(email);
      } catch (e) {
        rethrow;
      }
    } else {
      throw (PlatformException(
        code: 'EMPTY_EMAIL',
        message: 'Ingresa un email valido.',
      ));
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updatePasswordVerify(String passwordVerify) =>
      updateWith(passwordVerify: passwordVerify);

  void updateWith({
    String email,
    String password,
    String passwordVerify,
    FormType formType,
    bool isLoading,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.passwordVerify = passwordVerify ?? this.passwordVerify;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}
