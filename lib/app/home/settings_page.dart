import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inspirr/app/home/subscribe_page.dart';
import 'package:inspirr/services/auth.dart';
import 'package:inspirr/utils/platformAlertDialog.dart';
import 'package:inspirr/utils/screen_size.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final String did;
  final String email;
  final bool paidUser;

  const SettingsPage({Key key, this.did, this.email, this.paidUser})
      : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    final double _height = screenHeightExcludingBottombar(context);
    // final double _width = screenWidth(context);
    var myGroup = AutoSizeGroup();

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
          Image(
            image: AssetImage('assets/drawkit-support.png'),
            height: _height * .45,
            //fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
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
            height: _height * .30,
            child: _buildLayout(context, _height * .30, myGroup, _isAnon),
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

    Widget listTile;
    if (paidUser) {
      listTile = ListTile(
        title: AutoSizeText(
          'Cancelar suscripción',
          maxLines: 1,
          group: myGroup,
          style: TextStyle(
            fontSize: 20.0
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          print('TODO - CANCEL SUBSCRIPTION');
        },
      );
    } else {
      listTile = ListTile(
        title: AutoSizeText(
          '¿Quieres textos ilimitados?',
          maxLines: 1,
          group: myGroup,
          style: TextStyle(
            fontSize: 20.0
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => SubscribePage(isAnon: _isAnon),
            ),
          );
        },
      );
    }

    return Column(
      children: <Widget>[
        Container(
          height: height * .30,
          child: listTile,
        ),
        Container(
          height: height * .30,
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
          height: height * .30,
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
