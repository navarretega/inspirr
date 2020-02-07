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

    final double _height = screenHeight(context);
    // final double _width = screenWidth(context);

    Widget custom;
    bool _isAnon;
    if (email == null) {
      custom = SizedBox(
        height: 2.0,
      );
      _isAnon = true;
    } else {
      custom = Text(
        email,
        style: TextStyle(
          color: Color(0xFF272727),
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
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
          custom,
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 20.0),
            child: Divider(height: 1.5, thickness: 2.5),
          ),
          Container(
            // height: _height * .30,
            child: _buildLayout(context, _isAnon),
          ),
          SizedBox(height: 15.0),
          _customButton(context),
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
        // side: BorderSide(color: Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      color: Color(0xFF272727),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildLayout(context, _isAnon) {

    Widget listTile;
    if (paidUser) {
      listTile = ListTile(
        title: Text('Cancelar suscripción'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          print('TODO - CANCEL SUBSCRIPTION');
        },
      );
    } else {
      listTile = ListTile(
        title: Text('¿Quieres textos ilimitados?'),
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
        listTile,
        ListTile(
          title: Text('¿Necesitas ayuda?'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            PlatformAlertDialog(
              title: 'Te respondemos el mismo día',
              content: 'Mándanos un correo a alex@brisai.com',
              defaultActionText: 'OK',
            ).show(context);
          },
        ),
        ListTile(
          title: Text('Créditos'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            PlatformAlertDialog(
              title: 'Créditos',
              content:
                  'Icon made by Google from www.flaticon.com\nIcon made by geotatah from www.flaticon.com\nIcon made by Pixel perfect from www.flaticon.com\nIcon made by Icongeek26 from www.flaticon.com\nIcon made by mavadee from www.flaticon.com\nIcon made by Freepik from www.flaticon.com',
              defaultActionText: 'OK',
            ).show(context);
          },
        ),
      ],
    );
  }
}