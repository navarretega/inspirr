import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inspirr/utils/asset.dart';
import 'package:inspirr/utils/constants.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:share/share.dart';

class TextPage extends StatelessWidget {
  final String category;
  final String text;
  final String formattedDate2;

  const TextPage(
      {Key key,
      @required this.category,
      @required this.text,
      @required this.formattedDate2})
      : super(key: key);

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          'assets/robot-1.gif',
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

    final double _height = screenHeightExcludingToolbar(context);
    final double _width = screenWidth(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF272727)),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'IMPORTANTE',
              style: TextStyle(color: Color(0xFF272727)),
            ),
            onPressed: () {
              _showDialog(context);
            },
          ),
          RaisedButton(
            color: Color(0xFF272727),
            child: Text(
              'COMPARTIR',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Share.share('$text', subject: 'Comparte!');
            },
          )
        ],
      ),
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: _height * .15,
              width: _width,
              color: categoriesMap[category]['color'],
              child: Center(
                  child: AutoSizeText(
                    category,
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Color(0xFF083232),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/robot-2.png'),
                            // backgroundColor: categoriesMap[category]['color'],
                            radius: 25.0,
                          ),
                          Padding(padding: const EdgeInsets.fromLTRB(5, 0, 5, 0)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                categoriesMap[category]['author'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color.fromRGBO(47, 46, 65, 1),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              AutoSizeText(
                                '$formattedDate2',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ),
                      Divider(height: 1.5, thickness: 2.5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ),
                      AutoSizeText(
                        '$text',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(47, 46, 65, 1),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
