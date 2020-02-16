import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inspirr/app/home/subscribe_page.dart';
import 'package:inspirr/services/auth.dart';
import 'package:inspirr/utils/asset.dart';
import 'package:inspirr/utils/platformAlertDialog.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final String did;
  final String email;
  final int freeTexts;
  final int paidTexts;

  const SettingsPage({Key key, this.did, this.email, this.freeTexts, this.paidTexts})
      : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          'assets/robot-2.gif',
          fit: BoxFit.cover,
        ),
        title: Text(
          '¿Cómo funciona?',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        description: Text(
          '''Utilizamos algoritmos de Inteligencia Artificial para generar una variedad de textos sin intervención humana. En términos generales, la computadora aprende a escribir de la misma forma que un humano aprende. Esto es una analogía simplista que no representa en su totalidad la realidad, pero si ayuda a entender cómo funciona internamente.

Esencialmente a la computadora le enseñamos cientos de miles de textos hechos por humanos. El algoritmo que se utiliza internamente, basado en modelos matemáticos, aprende por si mismo a generar textos similares en base a los textos que ya ha visto. Es decir, le mostramos a la computadora miles de ensayos y esta aprende a formular sus propios ensayos.

Regresando a la analogía mencionada, si a un estudiante le damos a leer 100 ensayos de filosofía, el mismo estudiante podrá generar su propio ensayo en base a lo aprendido de esos ensayos que leyó. Asimismo, si a una computadora le damos 100 o incluso 1000 ensayos de filosofía, esta será capaz de generar sus propios ensayos en base a lo aprendido. Mientras mas textos le enseñes mejores resultados tendrá (Aplica tanto para las personas como las computadoras)

Ahora evidentemente el aprendizaje de un humano es diferente a la de una computadora, pero la Inteligencia Artificial trata emular de cierta forma al humano, pero ese ya es otro tema. 

Hablando sobre los textos que la computadora genera en esta aplicación, la gran mayoría de veces se forman textos coherentes y auténticos. Es decir, no son una copia de algo que ya hayan visto sino son textos únicos y creativos que hasta veces llegan a ser tan creativos que no son coherentes. 

No esperes que esta aplicación te genere tu ensayo de filosofía final de 5 páginas que tienes para mañana con una calificación de 100. Todavía no llegamos a ese nivel, pero estamos convencidos que pronto será posible. 

El primordial objetivo de esta aplicación es que la utilices para obtener ideas que te puedan inspirar a crear algo; no para hacer un ‘copy-paste’.

Si tienes alguna duda, comentario o te gustaría entender mas sobre nosotros escríbenos a alex@brisai.com'''
        ),
        onlyOkButton: true,
        onOkButtonPressed: () {
          Navigator.pop(context);
        },
        buttonOkColor: Color(0xFF272727),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final double _height = screenHeightExcludingBottombar(context);
    final double _width = screenWidth(context);
    var myGroup = AutoSizeGroup();
    final int _availableTexts = freeTexts + paidTexts;

    Widget custom;
    bool _isAnon;
    if (email == null) {
      custom = Center(
        child: AutoSizeText(
          'Anónimo',
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      _isAnon = true;
    } else {
      custom = Center(
        child: AutoSizeText(
          email,
          style: TextStyle(
            color: Color(0xFF272727),
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      _isAnon = false;
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 10.0),
            child: Divider(height: 1.5, thickness: 2.5),
          ),
          Container(
            height: _height * .05,
            child: custom,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: Divider(height: 1.5, thickness: 2.5),
          ),
          Container(
            height: _height * .10,
            width: _width,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: AutoSizeText(
                'Tienes $_availableTexts textos disponibles',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
          Container(
            height: _height * .35,
            child: _buildLayout(context, _height * .35, myGroup, _isAnon),
          ),
          SizedBox(height: 15.0),
          Container(
            height: _height * .08,
            child: _customButton(context),
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }

  Widget _customButton(context) {
    String buttonText;

    if (did == null) {
      buttonText = 'Cerrar sesión';
    } else {
      buttonText = 'Inicia sesión';
    }

    return RaisedButton(
      onPressed: () => _signOut(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0xFF272727),
      child: AutoSizeText(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildLayout(context, height, myGroup, _isAnon) {

    return Column(
      children: <Widget>[
        // Container(
        //   height: height * .25,
        //   child: ListTile(
        //     title: AutoSizeText(
        //       '¿Quieres más textos?',
        //       maxLines: 1,
        //       group: myGroup,
        //       style: TextStyle(fontSize: 20.0),
        //     ),
        //     trailing: Icon(Icons.arrow_forward_ios),
        //     onTap: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute<void>(
        //           fullscreenDialog: true,
        //           builder: (context) => SubscribePage(isAnon: _isAnon),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Container(
          height: height * .25,
          child: ListTile(
            title: AutoSizeText(
              '¿Cómo funciona?',
              maxLines: 1,
              group: myGroup,
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showDialog(context);
            },
          ),
        ),
        Container(
          height: height * .25,
          child: ListTile(
            title: AutoSizeText(
              '¿Necesitas ayuda?',
              maxLines: 1,
              group: myGroup,
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              PlatformAlertDialog(
                title: 'Te respondemos el mismo día',
                content: 'Mándanos un correo a alex@brisai.com',
                defaultActionText: 'OK',
              ).show(context);
            },
          ),
        ),
        Container(
          height: height * .25,
          child: ListTile(
            title: AutoSizeText(
              'Créditos',
              maxLines: 1,
              group: myGroup,
              style: TextStyle(fontSize: 20.0),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              PlatformAlertDialog(
                title: 'Créditos',
                content:
                    'Icon made by Google from www.flaticon.com\nIcon made by geotatah from www.flaticon.com\nIcon made by Pixel perfect from www.flaticon.com\nIcon made by Icongeek26 from www.flaticon.com\nIcon made by mavadee from www.flaticon.com\nIcon made by Freepik from www.flaticon.com\nIcon made by srip from www.flaticon.com',
                defaultActionText: 'OK',
              ).show(context);
            },
          ),
        ),
      ],
    );
  }
}
