import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/services/gpt2.dart';
import 'package:inspirr/utils/constants.dart';
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

  Future<void> _createText(String category, Database database, bool saveText) async {
    try {
      Gpt2 instance = Gpt2(category: category);
      await instance.getData();
      if (saveText) {
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

  Future<void> _validateUser(String category) async {
    try {
      widget.disableNav();
      setState(() { isLoading = true; });

      final database = Provider.of<Database>(context, listen: false);

      if (widget.did != null) {
        // ANON USER
        print('USER - ANON (DID: ${widget.did})');
        final Map data = await database.getAnonData();
        if (data['count'] <= 5) {
          // NO PAY-WALL
          print('PAY-WALL - NO (${data['count']}/5)');
          await database.setAnonFields(data['count'] + 1);
          await _createText(category, database, false);
        } else {
          // PAY-WALL
          print('PAY-WALL - YES (${data['count']}/5)');
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => SubscribePage(isAnon: true),
            ),
          );
        }
      } else {
        // EMAIL USER
        print('USER - EMAIL (UID)');
        final Map data = await database.getUserData();
        if (data['paidUser']) {
          print('USER STATUS - PREMIUM');
          // PAID USER
          await _createText(category, database, true);
        } else {
          // NORMAL USER
          print('USER STATUS - REGULAR');
          if (data['count'] <= 10) {
            // NO PAY-WALL
            print('PAY-WALL - NO (${data['count']}/10)');
            await database.setUserFields(data['count'] + 1, false);
            await _createText(category, database, true);
          } else {
            // PAY-WALL
            print('PAY-WALL - YES (${data['count']}/10)');
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (context) => SubscribePage(isAnon: false),
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
                          _buildCard(_height * .90, _width, myGroup, 'LIBRO', categoriesMap['LIBRO']['img'], categoriesMap['LIBRO']['color']),
                          _buildCard(_height * .90, _width, myGroup, 'ENSAYO', categoriesMap['ENSAYO']['img'], categoriesMap['ENSAYO']['color']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCard(_height * .90, _width, myGroup, 'PELICULA', categoriesMap['PELICULA']['img'], categoriesMap['PELICULA']['color']),
                          _buildCard(_height * .90, _width, myGroup, 'ARTICULO', categoriesMap['ARTICULO']['img'], categoriesMap['ARTICULO']['color']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCard(_height * .90, _width, myGroup, 'CITA', categoriesMap['CITA']['img'], categoriesMap['CITA']['color']),
                          _buildCard(_height * .90, _width, myGroup, 'MUSICA', categoriesMap['MUSICA']['img'], categoriesMap['MUSICA']['color']),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildCard(height, _width, myGroup, name, img, color) {
    return Material(
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
            _validateUser(name);
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
