import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/services/gpt2.dart';
import 'package:inspirr/utils/asset.dart';
import 'package:inspirr/utils/constants.dart';
import 'package:inspirr/utils/network.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:inspirr/services/database.dart';
import 'package:inspirr/app/home/subscribe_page.dart';
import 'package:inspirr/app/home/error_page.dart';
import 'package:inspirr/app/home/text_page.dart';
import 'package:inspirr/models/textAI.dart';

class MainPage extends StatefulWidget {
  final Function() disableNav;
  final String did;

  const MainPage({Key key, @required this.disableNav, this.did})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) => NetworkGiffyDialog(
        image: Image.network(
          'https://media.giphy.com/media/l46CwEYnbFtFfjZNS/giphy.gif',
          fit: BoxFit.cover,
        ),
        title: Text(
          'Proximamente',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        description: Text(
            '''Estamos entrenando nuestro modelo para que pueda generar otro tipo de textos como ensayos y letra de música.

Entendemos que lo que muchos buscan es hacer ensayos y por eso estamos tratando de tenerlo lo más pronto posible pero desafortunadamente requiere tiempo y esfuerzo. (Si te interesa saber cómo funciona checa en la sección de ‘settings’ para más detalles)
 
¿Tienes alguna recomendación o pregunta? Escribenos a alex@brisai.com
          '''),
        onlyOkButton: true,
        onOkButtonPressed: () {
          Navigator.pop(context);
        },
        buttonOkColor: Color(0xFF272727),
      ),
    );
  }

  Future<void> _createText(
      bool isAnon, String category, Database database) async {
    try {
      Gpt2 instance = Gpt2(category: category);
      await instance.getData();
      if (isAnon == false) {
        await database.createText(TextAI(
          category: instance.category,
          text: instance.text,
          formattedDate2: instance.formattedDate2,
          formattedDate: instance.formattedDate,
        ));
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => TextPage(
            category: instance.category,
            text: instance.text,
            formattedDate2: instance.formattedDate2,
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _validateUser(bool disable, String category) async {
    try {
      if (disable) {
        _showDialog();
      } else {
        widget.disableNav();
        setState(() {
          isLoading = true;
        });

        final database = Provider.of<Database>(context, listen: false);
        bool _isAnon;

        if (widget.did != null) {
          _isAnon = true;
        } else {
          _isAnon = false;
        }

        final Map data = await database.getUserData(_isAnon);
        final int _freeTexts = data['freeTexts'];
        final int _paidTexts = data['paidTexts'];

        if (_freeTexts >= 1) {
          print('Using free texts - $_freeTexts');
          await database.setUserFields(_isAnon, _freeTexts - 1, _paidTexts);
          await _createText(_isAnon, category, database);
        } else {
          if (_paidTexts >= 1) {
            print('Using paid texts - $_paidTexts');
            await database.setUserFields(_isAnon, _freeTexts, _paidTexts - 1);
            await _createText(_isAnon, category, database);
          } else {
            print('No available texts');
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (context) => SubscribePage(isAnon: true),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('ERROR: ${e.toString()}');
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => ErrorPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _height = screenHeightExcludingBottombar(context);
    final double _width = screenWidth(context);
    var myGroup = AutoSizeGroup();

    return isLoading
        ? _loading(_height)
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: _height * .10,
                  width: _width,
                  margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
                  child: Center(
                    child: AutoSizeText(
                      '¿Que buscas escribir?',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: _height * .90,
                  width: _width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCard(
                              _height * .90,
                              _width,
                              myGroup,
                              'LIBRO',
                              categoriesMap['LIBRO']['img'],
                              categoriesMap['LIBRO']['color'],
                              false),
                          _buildCard(
                              _height * .90,
                              _width,
                              myGroup,
                              'PELICULA',
                              categoriesMap['PELICULA']['img'],
                              categoriesMap['PELICULA']['color'],
                              false),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCard(
                              _height * .90,
                              _width,
                              myGroup,
                              'CITA',
                              categoriesMap['CITA']['img'],
                              categoriesMap['CITA']['color'],
                              false),
                          _buildCard(
                              _height * .90,
                              _width,
                              myGroup,
                              'ARTICULO',
                              categoriesMap['ARTICULO']['img'],
                              categoriesMap['ARTICULO']['color'],
                              false),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCard(
                              _height * .90,
                              _width,
                              myGroup,
                              'ENSAYO',
                              categoriesMap['ENSAYO']['img'],
                              categoriesMap['ENSAYO']['color'],
                              true),
                          _buildCard(
                              _height * .90,
                              _width,
                              myGroup,
                              'MUSICA',
                              categoriesMap['MUSICA']['img'],
                              categoriesMap['MUSICA']['color'],
                              true),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildCard(height, _width, myGroup, name, img, color, disable) {
//    if (disable) {
//      print('$name - $disable');
//    } else {
//      print('$name - $disable');
//    }
    return Opacity(
      opacity: disable ? 0.5 : 1.0,
      child: Material(
        child: Ink(
          height: height * .27,
          width: _width * .42,
          decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: AssetImage(img),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _validateUser(disable, name);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: AutoSizeText(
                name,
                group: myGroup,
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFF083232),
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loading(height) {
    return Center(
      child: Container(
        height: height,
        child: SpinKitChasingDots(
          color: Color(0xFF272727),
          size: 100.0,
        ),
      ),
    );
  }
}
