import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/app/home/text_page.dart';
import 'package:inspirr/models/textAI.dart';
import 'package:inspirr/services/database.dart';
import 'package:inspirr/utils/constants.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:provider/provider.dart';

class TextsPage extends StatelessWidget {

  final String did;

  const TextsPage({Key key, this.did}) : super(key: key);

  void _goToText(context, c, t, f) {
    print(c);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => TextPage(
          category: c.toUpperCase(),
          text: t,
          formattedDate2: f,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final double _height = screenHeightExcludingBottombar(context);
    final double _width = screenWidth(context);
    var myGroup = AutoSizeGroup();

    final database = Provider.of<Database>(context);
    if (did != null) {
      return _anon(_height, _width);
    } else {
      return StreamBuilder<List<TextAI>>(
        stream: database.textsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return _error(_height, _width);
          } else {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                final texts = snapshot.data;
                return _text(_height, _width, myGroup, texts, context);
              } else {
                return _noTexts(_height, _width);
              }
            } else {
              return _loading();
            }
          }
        },
      );
    }
  }

  Widget _text(_height, _width, myGroup, texts, context) {
    texts.sort((TextAI a, TextAI b) => b.formattedDate.compareTo(a.formattedDate));
    print('# Texts: ${texts.length}');
    if (texts.length >= 20) {
      print('Getting only the latest 20 texts');
      texts = texts.sublist(0, 20);
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
      itemCount: texts.length,
      itemBuilder: (_, index) {
        return _textCard(_height, _width, myGroup, texts, index, context);
      },
    );
  }

  Widget _textCard(height, width, myGroup, texts, index, context) {
    var category = texts[index].category;
    var text = texts[index].text;
    var formattedDate2 = texts[index].formattedDate2;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Ink(
        height: height * .18,
        child: InkWell(
          onTap: () {
            _goToText(context, category, text, formattedDate2);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width * .25,
                child: _thumbnail(categoriesMap[category]['color'], categoriesMap[category]['img']),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: _cardDescription(height * .18, myGroup, category, text, categoriesMap[category]['author'], formattedDate2),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail(color, img) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        image: DecorationImage(
          image: AssetImage(img),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _cardDescription(height, myGroup, category, text, author, formattedDate2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: height *.70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: (height *.50) * .30,
                child: AutoSizeText(
                  '$category',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Container(
                height: (height *.50) * .65,
                // color: Colors.blueGrey,
                child: AutoSizeText(
                  text,
                  // minFontSize: 15.0,
                  maxLines: 3,
                  group: myGroup,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: height * .30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: (height * .30) * .50,
                child: AutoSizeText(
                  '$author',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                height: (height * .30) * .50,
                child: AutoSizeText(
                  '$formattedDate2',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _error(_height, _width) {
    return Container(
      height: _height,
      width: _width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: AutoSizeText(
            'Tuvimos un problema. Intenta más tarde.',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _noTexts(_height, _width) {
    return Container(
      height: _height,
      width: _width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: AutoSizeText(
            'Aquí podrás ver todos tus textos.',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _anon(_height, _width) {
    return Container(
      height: _height,
      width: _width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: AutoSizeText(
            'Inicia sesión y aquí podrás ver todos tus textos.',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: SpinKitChasingDots(
        color: Color.fromRGBO(47, 46, 65, 1),
        size: 80.0,
      ),
    );
  }
}
