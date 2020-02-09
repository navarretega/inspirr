import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inspirr/utils/screen_size.dart';

class ErrorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double _height = screenHeight(context);
    final double _width = screenWidth(context);
    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/NoConnection.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(
                    ':(',
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 10.0),
                  AutoSizeText(
                    'Tuvimos un problema.',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Container(
                height: _height * .07,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, '/');
                  },
                  color: Colors.white,
                  child: AutoSizeText(
                    'INTENTAR DE NUEVO',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF272727),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
