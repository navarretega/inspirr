import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inspirr/app/home/text_page.dart';
import 'package:inspirr/models/textAI.dart';
import 'package:inspirr/services/database.dart';
import 'package:inspirr/utils/constants.dart';
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
    final database = Provider.of<Database>(context);
    if (did != null) {
      return _anon();
    } else {
      return StreamBuilder<List<TextAI>>(
        stream: database.textsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return _error();
          } else {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                final texts = snapshot.data;
                return _text(texts, context);
              } else {
                return _noTexts();
              }
            } else {
              return _loading();
            }
          }
        },
      );
    }
  }

  Widget _text(texts, context) {
    texts.sort((TextAI a, TextAI b) => b.formattedDate.compareTo(a.formattedDate));
    print('# Texts: ${texts.length}');
    if (texts.length >= 20) {
      print('Getting only the latest 20 texts');
      texts = texts.sublist(0, 20);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
      itemCount: texts.length,
      itemBuilder: (_, index) {
        // print(index);
        return _textCard(texts, index, context);
      },
    );
  }

  Widget _textCard(texts, index, context) {
    var category = texts[index].category;
    // print('$index - $category');
    var text = texts[index].text;
    var formattedDate2 = texts[index].formattedDate2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Ink(
        height: 100,
        child: InkWell(
          onTap: () {
            _goToText(context, category, text, formattedDate2);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: _thumbnail(categoriesMap[category]['color'],
                    categoriesMap[category]['img']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _cardDescription(category, text,
                      categoriesMap[category]['author'], formattedDate2),
                ),
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

  Widget _cardDescription(category, text, author, formattedDate2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$category',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$text',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$formattedDate2',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _error() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Text(
          'Tuvimos un problema.\nIntenta más tarde.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _noTexts() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Text(
          'Aquí podrás ver todos tus textos.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _anon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Text(
          'Inicia sesión y aquí podrás ver todos tus textos.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
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
