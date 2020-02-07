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

  void subscribe(context) {
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
      print('EMAIL USER - Proceed to payment');
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
              height: _height * .20,
              width: _width,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '¿Quieres más?',
                    style: TextStyle(
                      fontSize: 27.0,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Suscríbete para tener acceso a textos ilimitados',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: _height * .80,
              width: _width * .80,
              child: Column(
                children: <Widget>[
                  _basicPlanCard(_width, context),
                  SizedBox(height: 10.0),
                  _premiumPlanCard(_width, context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _basicPlanCard(width, context) {
    return Container(
      height: 200,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
//        boxShadow: [
//          BoxShadow(
//              color: Color(0xFF272727),
//              blurRadius: 2.0,
//              spreadRadius: 0.0,
//              offset: Offset(0.0, 1.0))
//        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Standard',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xFF272727),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '10 textos por día \n \$0 MXN / mes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0xFF272727),
              fontWeight: FontWeight.w500,
            ),
          ),
          _basicPlanButton(context)
        ],
      ),
    );
  }

  Widget _premiumPlanCard(width, context) {
    return Container(
      height: 200,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Premium',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xFF272727),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Textos ilimitados \n \$29 MXN / mes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0xFF272727),
              fontWeight: FontWeight.w500,
            ),
          ),
          _premiumPlanButton(context)
        ],
      ),
    );
  }

  Widget _basicPlanButton(context) {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color(0xFF272727)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Text(
        'SELECCIONAR',
        style: TextStyle(
          color: Color(0xFF272727),
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _premiumPlanButton(context) {
    return RaisedButton(
      onPressed: () {
        subscribe(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        // side: BorderSide(color: Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: Color(0xFF272727),
      child: Text(
        'SELECCIONAR',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
