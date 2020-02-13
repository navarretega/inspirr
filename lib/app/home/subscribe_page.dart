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
        child: Container(
          height: _height * .85,
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: (_height * .85) * .15,
                width: _width,
                child: Center(
                  child: AutoSizeText(
                    '¿Quieres más?',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: (_height * .85) * .05),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                '25 TEXTOS *',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            SizedBox(width: _width * .05),
                            SizedBox(
                              width: _width * .30,
                              child: RaisedButton(
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Color(0xFF272727),
                                child: AutoSizeText(
                                  'MXN \$29',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Divider(height: 1.0, thickness: 2.0,),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                '70 TEXTOS *',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            SizedBox(width: _width * .05),
                            SizedBox(
                              width: _width * .30,
                              child: RaisedButton(
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Color(0xFF272727),
                                child: AutoSizeText(
                                  'MXN \$29',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Divider(height: 1.0, thickness: 2.0,),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                '150 TEXTOS *',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            SizedBox(width: _width * .05),
                            SizedBox(
                              width: _width * .30,
                              child: RaisedButton(
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: Color(0xFF272727),
                                child: AutoSizeText(
                                  'MXN \$29',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
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
              ),
              SizedBox(height: (_height * .85) * .05),
              Container(
                height: (_height * .85) * .20,
                width: _width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: AutoSizeText(
                        '* Un texto equivale a escoger una categoria\n(Libro, Pelicula, Cita, Ensayo o Articulo)',
                        maxLines: 2,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Siempre tienes gratis 10 textos / dia',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 17.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
