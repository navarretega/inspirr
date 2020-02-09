import 'package:auto_size_text/auto_size_text.dart';
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

//  Future<void> _signInWithFacebook(BuildContext context) async {
//    try {
//      print('NOT AVAILABLE');
//      // await manager.signInWithFacebook();
//    } on PlatformException catch (e) {
//      if (e.code != 'ERROR_ABORTED_BY_USER') {
//        _showSignInError(context, e);
//      }
//    }
//  }

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _width * .05),
            child: Column(
              children: <Widget>[
                Container(
                  // color: Colors.greenAccent,
                  height: _height * .50,
                  child: _buildTitle(_height * .50, _width * .95),
                ),
                Container(
                  // color: Colors.red,
                  height: _height * .50,
                  child: isLoading
                      ? _loading()
                      : _buildButtons(_height * .50, _width * .95, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(height, width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          // color: Colors.yellow,
          height: height * .30,
          width: width,
          child: AutoSizeText(
            '¿Te falta inspiración?',
            maxLines: 2,
            style: TextStyle(
              fontSize: 100.0,
              color: Color(0xFF272727),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          // color: Colors.cyan,
          height: height * .23,
          width: width,
          child: AutoSizeText(
            'Inicia sesión y evita el síndrome del "No sé qué escribir".',
            maxLines: 3,
            style: TextStyle(
              fontSize: 100.0,
              color: Color(0xFF272727),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(height, width, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // _facebookButton(context), // FACEBOOK PLUGIN IS NOT WORKING ANYMORE
        Container(
          height: height * .15,
          width: width,
          child: _googleButton(height * .15, width, context),
        ),
        Container(
          height: height * .10,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Divider(
                  thickness: 3.0,
                  color: Colors.black12,
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                'O',
                style: TextStyle(
                  color: Color(0xFF272727),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Divider(
                  thickness: 3.0,
                  color: Colors.black12,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: height * .15,
          width: width,
          child: _emailButton(height * .15, width, context),
        ),
        SizedBox(height: 20.0),
        Container(
          height: height * .07,
          width: width,
          child: _skipButton(context),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget _googleButton(height, width, context) {
    return RaisedButton(
      onPressed: () => _signInWithGoogle(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0xFF272727),
      child: Row(
        children: <Widget>[
          Container(
            width: width * .60,
            child: AutoSizeText(
              'Continua con Google',
              maxLines: 1,
              maxFontSize: 25.0,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/google-logo.png',
                height: height * .50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

//  Widget _facebookButton(context) {
//    return RaisedButton(
//      onPressed: () => _signInWithFacebook(context),
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(10.0),
//        // side: BorderSide(color: Colors.white),
//      ),
//      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
//      color: Color(0xFF272727),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Text(
//            'Continua con Facebook',
//            style: TextStyle(
//              color: Colors.white,
//              fontSize: 20.0,
//              fontWeight: FontWeight.w300,
//            ),
//          ),
//          Image.asset(
//            'assets/facebook-logo.png',
//            height: 20.0,
//            width: 20.0,
//            color: Colors.white,
//          ),
//        ],
//      ),
//    );
//  }

  Widget _emailButton(height, width, context) {
    return RaisedButton(
      onPressed: () => _signInWithEmail(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0xFF272727),
      child: Row(
        children: <Widget>[
          Container(
            width: width * .60,
            child: AutoSizeText(
              'Continua con Email',
              maxLines: 1,
              maxFontSize: 25.0,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/email.png',
                height: height * .50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skipButton(context) {
    return FlatButton(
      onPressed: () => _signInAnonymously(context),
      splashColor: Colors.white,
      child: AutoSizeText(
        'Omitir',
        maxLines: 1,
        style: TextStyle(
          fontSize: 50.0,
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
        size: 90.0,
      ),
    );
  }
}
