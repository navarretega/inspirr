import 'package:auto_size_text/auto_size_text.dart';
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
        content:
            'Por favor verifica tu email revisando el correo que te acabamos de mandar.',
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
          child: Column(
            children: <Widget>[
              Container(
                height: _height * .30,
                width: _width * .80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: (_height * .30) * .40,
                      child: AutoSizeText(
                        'No tienes que ser escritor.',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 50.0,
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 50.0,),
              Container(
                height: _height * .70,
                width: _width * .80,
                child: widget.model.isLoading ? _loading() : _form(_height * .70, _width * .80),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(height, width) {
    if (widget.model.formType == FormType.signIn) {
      return _signInForm(height, width);
    } else if (widget.model.formType == FormType.register) {
      return _registerForm(height);
    } else {
      return _resetPasswordForm(height);
    }
  }

  Widget _signInForm(height, width) {

    var myGroup = AutoSizeGroup();

    return Column(
      children: <Widget>[
        _emailField(height, _emailEditingComplete, TextInputAction.next),
        SizedBox(height: 10.0),
        _passwordField(height, _signInWithEmailAndPassword, TextInputAction.done),
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.only(left: width * .20),
          child: Container(
            height: height * .05,
            child: FlatButton(
              onPressed: () => _setFormType(FormType.forgotPassword),
              splashColor: Colors.white,
              child: AutoSizeText(
                '¿Olvidaste tu contraseña?',
                group: myGroup,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF272727)
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40.0),
        Container(
          height: height * .10,
          child: RaisedButton(
            onPressed: _signInWithEmailAndPassword,
            color: Color(0xFF272727),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              // side: BorderSide(color: Colors.white),
            ),
            child: AutoSizeText(
              'Inicia sesión',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        SizedBox(height: 40.0),
        Container(
          height: height * .05,
          child: FlatButton(
            onPressed: () => _setFormType(FormType.register),
            splashColor: Colors.white,
            child: AutoSizeText(
              '¿Primera vez aquí? Regístrate',
              group: myGroup,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(47, 46, 65, 1),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _registerForm(height) {
    return Column(
      children: <Widget>[
        _emailField(height, _emailEditingComplete, TextInputAction.next),
        SizedBox(height: 10.0),
        _passwordField(height, _passwordEditingComplete, TextInputAction.next),
        SizedBox(height: 10.0),
        _passwordVerifyField(height),
        SizedBox(height: 40.0),
        Container(
          height: height * .12,
          child: RaisedButton(
            onPressed: _createUserWithEmailAndPassword,
            color: Color(0xFF272727),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              // side: BorderSide(color: Colors.white),
            ),
            child: AutoSizeText(
              'Registrate',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _resetPasswordForm(height) {
    return Column(
      children: <Widget>[
        _emailField(height, _resetPassword, TextInputAction.done),
        SizedBox(height: 40.0),
        Container(
          height: height * .12,
          child: RaisedButton(
            onPressed: _resetPassword,
            color: Color(0xFF272727),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              // side: BorderSide(color: Colors.white),
            ),
            child: AutoSizeText(
              'Reinicia tu contraseña',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _emailField(double height, VoidCallback onEditingComplete, TextInputAction inputAction) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFFA93F55),
        hintColor: Colors.grey,
      ),
      child: TextField(
        style: TextStyle(fontSize: height * .05),
        controller: _emailController,
        focusNode: _emailFocusNode,
        onEditingComplete: onEditingComplete,
        onChanged: widget.model.updateEmail,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: inputAction,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, size: height * .05),
          hintText: 'Tu email',
        ),
        cursorColor: Color(0xFFA93F55),
      ),
    );
  }

  Widget _passwordField(double height, VoidCallback onEditingComplete, TextInputAction inputAction) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFFA93F55),
        hintColor: Colors.grey,
      ),
      child: TextField(
        style: TextStyle(fontSize: height * .05),
        controller: _passController,
        focusNode: _passFocusNode,
        onEditingComplete: onEditingComplete,
        onChanged: widget.model.updatePassword,
        textInputAction: inputAction,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, size: height * .05),
          hintText: 'Tu contraseña',
        ),
        cursorColor: Color(0xFFA93F55),
      ),
    );
  }

  Widget _passwordVerifyField(height) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xFFA93F55),
        hintColor: Colors.grey,
      ),
      child: TextField(
        style: TextStyle(fontSize: height * .05),
        controller: _passVerifyController,
        focusNode: _passVerifyFocusNode,
        onEditingComplete: _createUserWithEmailAndPassword,
        onChanged: widget.model.updatePasswordVerify,
        textInputAction: TextInputAction.done,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, size: height * .05),
          hintText: 'Tu contraseña',
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
