import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:inspirr/utils/platformAlertDialog.dart';

class PlatFormExceptionMessages extends PlatformAlertDialog {
  final String title;
  final PlatformException exception;

  PlatFormExceptionMessages({
    @required this.title,
    @required this.exception,
  }) : super(title: title, content: _message(exception), defaultActionText: 'OK');

  static String _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    // signInWithEmailAndPassword
    'ERROR_INVALID_EMAIL': 'Verifica que estés utilizando un email válido.',
    'ERROR_WRONG_PASSWORD': 'Contraseña incorrecta. Inténtalo de nuevo.',
    'ERROR_USER_NOT_FOUND': 'El email que ingresaste no pertenece a una cuenta. Crea una cuenta nueva si no tienes una.',
    // createUserWithEmailAndPassword
    'ERROR_WEAK_PASSWORD': 'Tu contraseña debe tener al menos 6 caracteres.',
    'ERROR_EMAIL_ALREADY_IN_USE': 'El email que ingresaste ya se ha registrado anteriormente. Intenta iniciar sesión con él.',
  };

}
