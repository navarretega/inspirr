import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/app/landing_page.dart';
import 'package:inspirr/services/auth.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key key}) : super(key: key);

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstRun', true);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Provider<AuthBase>(
            create: (context) => Auth(), child: LandingPage()),
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 250.0),
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasError) {
            print('ERROR - ${snapshot.error}');
            return Scaffold(
              body: Center(
                  child: Text(
                      'Disculpa. Estamos teniendo problemas.\nIntenta de nuevo mas tarde.')),
            );
          } else {
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data.getBool('firstRun') == null) {
                print('New device - Getting Intro');
                return _buildIntroScreen(context);
              } else {
                print('Existing device - Getting Auth');
                return Provider<AuthBase>(
                  create: (context) => Auth(),
                  child: LandingPage(),
                );
              }
            } else {
              print('LOADING');
              return Scaffold(
                body: Center(
                  child: SpinKitChasingDots(
                    color: Color.fromRGBO(47, 46, 65, 1),
                    size: 90.0,
                  ),
                ),
              );
            }
          }
        });

    //return _buildIntroScreen(context);
  }

  IntroductionScreen _buildIntroScreen(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: '"No sé de qué escribir"',
          body:
              "Para aquellos que quieren escribir algo pero no saben por dónde empezar.",
          image: _buildImage('question'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: '"No tengo tiempo"',
          body:
              "Para aquellos que tienen prisa y requieren algo rápido (y bueno).",
          image: _buildImage('waiting'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: '"Odio escribir"',
          body: "Para aquellos que no les gusta, pero lo requieren.",
          image: _buildImage('day_dreaming_'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "¿Te sentiste identificado?",
          body:
              "Te ayudamos a escribir lo que requieras inmediatamente con textos auténticos e irrepetibles generados por la Inteligencia Artificial.",
          image: _buildImage('idea'),
//          footer: RaisedButton(
//            onPressed: () {/* Nothing */},
//            child: const Text(
//              '¿Como funciona?',
//              style: TextStyle(color: Colors.white),
//            ),
//            color: Colors.lightBlue,
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8.0),
//            ),
//          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('OMITIR'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('LISTO', style: TextStyle(fontWeight: FontWeight.w700)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: Color(0xFF272727),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
