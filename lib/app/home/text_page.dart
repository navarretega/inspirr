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

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          'assets/robot.gif',
          fit: BoxFit.cover,
        ),
        title: Text(
          'Considera lo siguiente',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        description: Text('Estamos utilizando algoritmos de Inteligencia Artificial para generar párrafos únicos irrepetibles. Es decir, los textos que generamos están 100% hechos por una computadora sin intervención humana.\n\nLa mayoría de veces es capaz de generar párrafos de cierta forma coherente y fluida, y si lo leyeras, difícilmente pensaras que una computadora fue capaz de general algo así.\n\nSin embargo, este no es siempre el caso. Es probable que a veces resulte en textos sin sentido alguno, y eso es completamente normal (Solo intenta generar texto de nuevo).\n\nNo existe ningún algoritmo capaz de generar textos o ensayos 100% coherentes sobre un tema en específico. Estamos seguros de que en un futuro eso será posible, pero por el momento no lo es.\n\nSi te interesa saber sobre el algoritmo detrás de esta aplicación, puedes leer el siguiente link https://openai.com/blog/better-language-models/'),
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
              '¿COMO FUNCIONA?',
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
