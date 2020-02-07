import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/services/auth.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:inspirr/app/sign_in/email_sign_in_page.dart';
import 'package:inspirr/app/sign_in/sign_in_manager.dart';
import 'package:provider/provider.dart';
import 'package:inspirr/utils/platformExceptionMessages.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;

  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatFormExceptionMessages(
      title: 'No pudimos iniciar sesión',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        print(e);
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      print('NOT AVAILABLE');
      // await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage.create(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _height = screenHeight(context);
    final double _width = screenWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          color: Color(0xFFf1f1f6),
          child: Column(
            children: <Widget>[
              Container(
                height: _height * .15,
                width: _width,
                // color: Color(0xFFA93F55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(),
                  ],
                ),
              ),
              Container(
                height: _height * .40,
                width: _width,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: _buildTitle(),
              ),
              Container(
                height: _height * .45,
                width: _width,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: isLoading ? _loading() : _buildButtons(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '¿Te falta inspiración?',
          style: TextStyle(
            fontSize: 35.0,
            color: Color(0xFF272727),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Inicia sesión y evita el síndrome del "No sé qué escribir".',
          style: TextStyle(
            fontSize: 25.0,
            color: Color(0xFF272727),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // SizedBox(height: 10.0),
        // _facebookButton(context), // TODO FACEBOOK PLUGIN IS NOT WORKING ANYMORE
        SizedBox(height: 10.0),
        _googleButton(context),
        SizedBox(height: 15.0),
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                height: 1.0,
                thickness: 2.0,
                color: Colors.black12,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              'O',
              style: TextStyle(color: Color(0xFF272727)),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Divider(
                height: 1.0,
                thickness: 2.0,
                color: Colors.black12,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        _emailButton(context),
        SizedBox(height: 5.0),
        _skipButton(context),
      ],
    );
  }

  Widget _googleButton(context) {
    return RaisedButton(
      onPressed: () => _signInWithGoogle(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(color: Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: Color(0xFF272727),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Continua con Google',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Image.asset(
            'assets/google-logo.png',
            height: 20.0,
            width: 20.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton(context) {
    return RaisedButton(
      onPressed: () => _signInWithFacebook(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(color: Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: Color(0xFF272727),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Continua con Facebook',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Image.asset(
            'assets/facebook-logo.png',
            height: 20.0,
            width: 20.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _emailButton(context) {
    return RaisedButton(
      onPressed: () => _signInWithEmail(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(color: Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: Color(0xFF272727),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Prefiero usar Email',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Image.asset(
            'assets/email.png',
            height: 20.0,
            width: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _skipButton(context) {
    return FlatButton(
      onPressed: () => _signInAnonymously(context),
      splashColor: Colors.white,
      child: Text(
        'Omitir',
        style: TextStyle(
          fontSize: 20.0,
          decoration: TextDecoration.underline,
          color: Color(0xFF272727),
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: SpinKitChasingDots(
        color: Color.fromRGBO(47, 46, 65, 1),
        size: 80.0,
      ),
    );
  }
}
