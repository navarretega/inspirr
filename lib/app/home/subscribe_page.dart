import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inspirr/services/auth.dart';
import 'package:inspirr/utils/platformAlertDialog.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:provider/provider.dart';

class SubscribePage extends StatelessWidget {
  final bool isAnon;

  const SubscribePage({Key key, @required this.isAnon}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void subscribe(context, subscription) {
    if (isAnon) {
      print('ANON USER - Need to log in first');
      _signOut(context);
      Navigator.of(context).pop();
      PlatformAlertDialog(
        title: 'Entra a tu cuenta',
        content: 'Inicia sesión o regístrate si aún no tienes una cuenta.',
        defaultActionText: 'OK',
      ).show(context);
    } else {
      print('EMAIL USER - $subscription - Proceed to payment');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _height = screenHeightExcludingToolbar(context);
    final double _width = screenWidth(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF272727)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: _height * .15,
              width: _width,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: (_height * .15) * .50,
                    width: _width,
                    child: Center(
                      child: AutoSizeText(
                        '¿Quieres más?',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: (_height * .15) * .50,
                    width: _width,
                    child: Center(
                      child: AutoSizeText(
                        'Suscríbete para tener acceso a textos ilimitados',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: _height * .80,
              width: _width * .80,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  _proPlanCard(_height * .80, _width * .80, context),
                  SizedBox(height: 25.0),
                  _premiumPlanCard(_height * .80, _width * .80, context),
                  Container(
                    height: (_height * .80) * .20,
                    width: _width * .80,
                    child: FlatButton(
                      onPressed: () { Navigator.of(context).pop(); },
                      child: AutoSizeText(
                        'Continua gratis (10 textos / dia)',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _proPlanCard(height, width, context) {
    return Container(
      height: height * .35,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD0D0D0),
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: (height * .35) * .25,
            child: AutoSizeText(
              'Pro',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                color: Color(0xFF272727),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            height: (height * .30) * .25,
            child: AutoSizeText(
              '50 textos por día \n \$29 MXN / mes',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Color(0xFF272727),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: (height * .35) * .25,
            child: _proPlanButton(context),
          )
        ],
      ),
    );
  }

  Widget _premiumPlanCard(height, width, context) {
    return Container(
      height: height * .35,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF272727),
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: (height * .35) * .25,
            child: AutoSizeText(
              'Premium',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                color: Color(0xFF272727),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            height: (height * .30) * .25,
            child: AutoSizeText(
              'Textos ilimitados \n \$49 MXN / mes',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Color(0xFF272727),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: (height * .35) * .25,
            child: _premiumPlanButton(context),
          )
        ],
      ),
    );
  }

  Widget _proPlanButton(context) {
    return RaisedButton(
      onPressed: () {
        subscribe(context, 'PRO');
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color(0xFF272727)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: AutoSizeText(
        'SELECCIONAR',
        style: TextStyle(
          color: Color(0xFF272727),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _premiumPlanButton(context) {
    return RaisedButton(
      onPressed: () {
        subscribe(context, 'PREMIUM');
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(color: Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: Color(0xFF272727),
      child: AutoSizeText(
        'SELECCIONAR',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
