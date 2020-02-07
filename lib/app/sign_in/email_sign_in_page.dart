import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/app/sign_in/email_sign_in_model.dart';
import 'package:inspirr/services/auth.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:inspirr/utils/platformExceptionMessages.dart';
import 'package:inspirr/utils/platformAlertDialog.dart';
import 'package:flutter/services.dart';

class EmailSignInPage extends StatefulWidget {

  final EmailSignInModel model;
  const EmailSignInPage({Key key, @required this.model}) : super(key: key);


  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => EmailSignInPage(model: model),
      ),
    );
  }

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passVerifyController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _passVerifyFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _passVerifyController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _passVerifyFocusNode.dispose();
    super.dispose();
  }

  void _setFormType(FormType f) {
    widget.model.updateWith(
        email: '',
        password: '',
        passwordVerify: '',
        formType: f,
        isLoading: false);
    _emailController.clear();
    _passController.clear();
    _passVerifyController.clear();
  }

  void _emailEditingComplete() {
    final newFocus =
    widget.model.email.isNotEmpty ? _passFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _passwordEditingComplete() {
    final newFocus = widget.model.password.isNotEmpty
        ? _passVerifyFocusNode
        : _passFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await widget.model.signInWithEmailAndPassword();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatFormExceptionMessages(
        title: 'No pudimos iniciar sesión',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await widget.model.createUserWithEmailAndPassword();
      Navigator.of(context).pop();
      PlatformAlertDialog(
        title: 'Verifica tu email',
        content: 'Por favor verifica tu email revisando el correo que te acabamos de mandar.',
        defaultActionText: 'OK',
      ).show(context);
    } on PlatformException catch (e) {
      PlatFormExceptionMessages(
        title: 'No pudimos crearte una cuenta',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _resetPassword() async {
    try {
      await widget.model.resetPassword();
      Navigator.of(context).pop();
      PlatformAlertDialog(
        title: 'Revisa tu email!',
        content: 'Te enviamos instrucciones para reiniciar tu contraseña.',
        defaultActionText: 'OK',
      ).show(context);
    } catch (e) {
      PlatFormExceptionMessages(
        title: 'Hubo un problema reiniciando tu contraseña',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _height = screenHeightExcludingToolbar(context);
    final double _width = screenWidth(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFF272727),
        ),
        backgroundColor: Color(0xFFf1f1f6),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          color: Color(0xFFf1f1f6),
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'No tienes que ser escritor.',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: Color(0xFF272727),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 50.0,),
                widget.model.isLoading ? _loading() : _form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    if (widget.model.formType == FormType.signIn) {
      return _signInForm();
    } else if (widget.model.formType == FormType.register) {
      return _registerForm();
    } else {
      return _resetPasswordForm();
    }
  }

  Widget _signInForm() {
    return Column(
      children: <Widget>[
        _emailField(_emailEditingComplete, TextInputAction.next),
        SizedBox(height: 10.0),
        _passwordField(_signInWithEmailAndPassword, TextInputAction.done),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () => _setFormType(FormType.forgotPassword),
              splashColor: Colors.white,
              child: Text(
                '¿Olvidaste tu contraseña?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF272727),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        RaisedButton(
          onPressed: _signInWithEmailAndPassword,
          color: Color(0xFF272727),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            // side: BorderSide(color: Colors.white),
          ),
          child: Text(
            'Inicia sesión',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        FlatButton(
          onPressed: () => _setFormType(FormType.register),
          splashColor: Colors.white,
          child: Text(
            '¿Primera vez aquí? Regístrate',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(47, 46, 65, 1),
            ),
          ),
        )
      ],
    );
  }

  Widget _registerForm() {
    return Column(
      children: <Widget>[
        _emailField(_emailEditingComplete, TextInputAction.next),
        SizedBox(height: 10.0),
        _passwordField(_passwordEditingComplete, TextInputAction.next),
        SizedBox(height: 10.0),
        _passwordVerifyField(),
        SizedBox(height: 20.0),
        RaisedButton(
          onPressed: _createUserWithEmailAndPassword,
          color: Color(0xFF272727),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            // side: BorderSide(color: Colors.white),
          ),
          child: Text(
            'Registrate',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }

  Widget _resetPasswordForm() {
    return Column(
      children: <Widget>[
        _emailField(_resetPassword, TextInputAction.done),
        SizedBox(height: 20.0),
        RaisedButton(
          onPressed: _resetPassword,
          color: Color(0xFF272727),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            // side: BorderSide(color: Colors.white),
          ),
          child: Text(
            'Reinicia tu contraseña',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }

  Widget _emailField(
      VoidCallback onEditingComplete, TextInputAction inputAction) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFFA93F55),
        hintColor: Colors.grey,
      ),
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        onEditingComplete: onEditingComplete,
        onChanged: widget.model.updateEmail,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: inputAction,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: 'Tu email',
        ),
        cursorColor: Color(0xFFA93F55),
      ),
    );
  }

  Widget _passwordField(VoidCallback onEditingComplete, TextInputAction inputAction) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFFA93F55),
        hintColor: Colors.grey,
      ),
      child: TextField(
        controller: _passController,
        focusNode: _passFocusNode,
        onEditingComplete: onEditingComplete,
        onChanged: widget.model.updatePassword,
        textInputAction: inputAction,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          hintText: 'Tu contraseña',
        ),
        cursorColor: Color(0xFFA93F55),
      ),
    );
  }

  Widget _passwordVerifyField() {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFFA93F55),
        hintColor: Colors.grey,
      ),
      child: TextField(
        controller: _passVerifyController,
        focusNode: _passVerifyFocusNode,
        onEditingComplete: _createUserWithEmailAndPassword,
        onChanged: widget.model.updatePasswordVerify,
        textInputAction: TextInputAction.done,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          hintText: 'Vuelve a ingresar tu contraseña',
        ),
        cursorColor: Color(0xFFA93F55),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: SpinKitChasingDots(
        color: Color.fromRGBO(47, 46, 65, 1),
        size: 100.0,
      ),
    );
  }

}
